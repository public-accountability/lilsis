# frozen_string_literal: true

# rubocop:disable Rails/Output, Metrics/MethodLength

class EntityMerger
  attr_reader :source, :dest, :extensions,
              :contact_info, :lists, :images,
              :aliases, :document_ids, :tag_ids,
              :articles, :os_categories,
              :child_entities, :party_members, :cmp_entity,
              :relationships, :potential_duplicate_relationships,
              :os_match_relationships, :ny_match_relationships,
              :external_links

  def initialize(source:, dest:)
    @source = source
    @dest = dest
    check_input_validity
    reset_instance_vars
  end

  # the actual merging
  def merge!
    merge

    ApplicationRecord.transaction do
      @extensions.each { |e| e.merge!(@dest) }
      @contact_info.each(&:save!)
      @contact_info_to_delete.each(&:destroy!)
      @source.external_links.each(&:destroy!)
      @external_links.each(&:save!)
      @lists.each { |list_id| ListEntity.create!(list_id: list_id, entity_id: dest.id) }
      @images.each(&:save!)
      @aliases.each(&:save!)
      @document_ids.each { |doc_id| @dest.references.find_or_create_by(document_id: doc_id) }
      @tag_ids.each { |tag_id| dest.add_tag(tag_id) }
      @articles.each(&:save!)
      @child_entities.each(&:merge!)
      @party_members.each(&:merge!)
      @cmp_entity&.save!
      @os_categories.each(&:save!)
      @relationships.each(&:merge!)
      @locations.each(&:save!)
      merge_os_donations!
      merge_ny_donations!
      transfer_ny_filer_entity!
      replace_os_match_cmte_id!
      set_merged_id_and_delete
    end
  end

  # trial run
  def report
    merge
    cp = ColorPrinter
    puts "Merging #{cp.colorize(source.name, :red)} (#{cp.colorize(source.id, :bg_red) }) into #{cp.colorize(dest.name, :red)} (#{cp.colorize(dest.id, :bg_red)})"

    unless @extensions.length.zero?
      puts cp.cyan("Adding or updating ") + cp.red(@extensions.count.to_s) + cp.cyan(" extensions")
    end

    unless @contact_info.length.zero?
      puts cp.cyan("Transferring ") + cp.red(@contact_info.count.to_s) + cp.cyan(" contact info models")
    end

    unless @lists.length.zero?
      puts cp.cyan("Putting the merged entity on ") + cp.red(@lists.count.to_s) + cp.cyan(" new lists")
    end

    unless @relationships.length.zero?
      puts cp.cyan("Transfering ") + cp.red(@relationships.count.to_s) + cp.cyan(" Relationships")
    end

    unless @potential_duplicate_relationships.length.zero?
      puts cp.red("NOTICE: ") + cp.cyan("found ") + cp.blue(@potential_duplicate_relationships.count.to_s) + cp.cyan(' potential duplicate relationships')
    end

    unless @aliases.length.zero?
      puts cp.cyan("adding ") + cp.red(@aliases.length.to_s) + cp.cyan(" aliases: ") + cp.blue(@aliases.map(&:name).join(', '))
    end

    unless @document_ids.length.zero?
      puts cp.cyan("Transfering ") + cp.red(@document_ids.count.to_s) + cp.cyan(" documents")
    end

    unless @tag_ids.length.zero?
      puts cp.cyan("Transfering ") + cp.red(@tag_ids.count.to_s) + cp.cyan(" tags: ") + cp.blue(@tag_ids.map { |t| Tag.find(t).name }.join(', '))
    end

    unless @locations.length.zero?
      puts cp.cyan("Transfering ") + cp.red(@locations.count) + cp.cyan(" locations")
    end
  end

  def merge
    merge_extensions
    merge_contact_info
    merge_external_links
    merge_lists
    merge_images
    merge_aliases
    merge_references
    merge_tags
    merge_articles
    merge_os_categories
    merge_child_entities
    merge_party_members
    merge_cmp_entity
    merge_relationships
    merge_locations
    self
  end

  ## Merge Functions ##

  Extension = Struct.new(:ext_id, :new, :fields) do
    def initialize(ext_id, new, fields = {})
      super
    end

    def merge!(dest)
      if self.new
        dest.add_extension(ext_id, fields)
      else
        dest.merge_extension(ext_id, fields)
      end
    end
  end

  def merge_extensions
    source_extension_attributes = source.extensions_with_attributes
    # new extensions
    (source.extension_ids.to_set - dest.extension_ids.to_set).each do |ext_id|
      if Entity.extension_with_field?(ext_id)
        @extensions << Extension.new(ext_id, true, source_extension_attributes[Entity.ext_name_or_id_to_name(ext_id)])
      else
        @extensions << Extension.new(ext_id, true)
      end
    end

    # common extensions:
    source.extension_ids.to_set.intersection(dest.extension_ids.to_set).each do |ext_id|
      if Entity.extension_with_field?(ext_id)
        @extensions << Extension.new(ext_id, false, source_extension_attributes[Entity.ext_name_or_id_to_name(ext_id)])
      end
    end
  end

  def merge_external_links
    dest_elink_types = @dest.external_links.map(&:link_type).map(&:to_sym)

    source.external_links.to_a.map do |external_link|
      link_type = external_link.link_type.to_sym

      if dest_elink_types.include?(link_type) && !ExternalLink::LINK_TYPES.dig(link_type, :multiple)
        raise ConflictingExternalLinksError.new(link_type)
      else
        new_link = external_link.dup
        new_link.assign_attributes(entity: @dest)
        @external_links << new_link
      end
    end
  end

  def merge_contact_info
    source.addresses.each do |address|
      unless dest.addresses.present? && dest.addresses.select { |dest_a| dest_a.same_as?(address) }.present?
        @contact_info << address.dup.tap(&set_dest_entity_id)
        @contact_info_to_delete << address
      end
    end

    source.emails.each do |email|
      unless dest.emails.present? && dest.emails.map(&:address).include?(email.address)
        @contact_info << email.dup.tap(&set_dest_entity_id)
        @contact_info_to_delete << email
      end
    end

    source.phones.each do |phone|
      unless dest.phones.present? && dest.phones.map(&:number).include?(phone.number)
        @contact_info << phone.dup.tap(&set_dest_entity_id)
        @contact_info_to_delete << phone
      end
    end
  end

  def merge_lists
    @lists = source.list_entities.pluck(:list_id).to_set - dest.list_entities.pluck(:list_id).to_set
  end

  def merge_images
    @images = @source.images.map { |img| img.tap(&set_dest_entity_id) }
  end

  def merge_aliases
    source.aliases.each do |a|
      unless dest.aliases.map(&:name).include?(a.name)
        @aliases << Alias.new(name: a.name, entity_id: dest.id, is_primary: false)
      end
    end
  end

  def merge_references
    @document_ids = source.references.map(&:document_id).to_set - dest.references.map(&:document_id).to_set
  end

  def merge_tags
    @tag_ids = source.taggings.map(&:tag_id).to_set - dest.taggings.map(&:tag_id).to_set
  end

  def merge_articles
    @articles = source
                  .article_entities
                  .reject { |ae| dest.article_entities.where(article_id: ae.article_id).exists? }
                  .map { |ae| ae.tap { |x| x.entity_id = dest.id } }
  end

  def merge_os_categories
    @os_categories = source
                       .os_entity_categories
                       .reject { |oec| dest.os_entity_categories.where(category_id: oec.category_id).exists? }
                       .map { |oec| oec.tap(&set_dest_entity_id) }
  end

  MergedRelationship = Struct.new(:relationship, :docs) do
    def merge!
      relationship.save!
      docs.each { |doc_id| relationship.references.find_or_create_by(document_id: doc_id) }
    end
  end

  def merge_relationships
    source.relationships.includes(:os_matches).each do |relationship|
      # OpenSecrets Relationships are handled in merge_os_donations!
      if relationship.os_matches.exists?
        @os_match_relationships << relationship
        next
      end

      if relationship.ny_matches.exists?
        @ny_match_relationships << relationship
        next
      end

      attributes = relationship.attributes.except('id', 'entity1_id', 'entity2_id', 'updated_at', 'created_at')

      if relationship.entity1_id == source.id
        attributes.merge!('entity1_id' => dest.id, 'entity2_id' => relationship.entity2_id)
      elsif relationship.entity2_id == source.id
        attributes.merge!('entity2_id' => dest.id, 'entity1_id' => relationship.entity1_id)
      else
        raise Exceptions::ThatsWeirdError
      end

      new_relationship = Relationship.new(attributes)

      @relationships << MergedRelationship.new(new_relationship, relationship.document_ids)

      if dest_relationship_lookup.include?(new_relationship.triplet)
        @potential_duplicate_relationships << new_relationship
      end
    end
  end

  def merge_os_donations!
    @os_match_relationships.each do |rel|
      if rel.entity1_id == source.id
        os_donation_ids = rel.os_matches.map(&:os_donation_id)
        rel.os_matches.each(&:destroy!)
        os_donation_ids.each { |i| OsMatch.create!(os_donation_id: i, donor_id: dest.id) }
      elsif rel.entity2_id == source.id
        rel.os_matches.each { |m| m.update!(recip_id: dest.id) }
        rel.update!(entity2_id: dest.id)
      else
        raise Exceptions::ThatsWeirdError
      end
    end
  end

  def replace_os_match_cmte_id!
    OsMatch.where(cmte_id: source.id).update_all(cmte_id: dest.id)
  end

  def transfer_ny_filer_entity!
    NyFilerEntity.where(entity_id: source.id).update_all(entity_id: dest.id)
  end

  def merge_ny_donations!
    @ny_match_relationships.each do |rel|
      if rel.entity1_id == source.id
        ny_disclosure_ids = rel.ny_matches.map(&:ny_disclosure_id)
        rel.ny_matches.each(&:unmatch!)
        ny_disclosure_ids.each { |i| NyMatch.match(i, dest.id) }
      elsif rel.entity2_id == source.id
        rel.ny_matches.each { |m| m.update!(recip_id: dest.id) }
        rel.update!(entity2_id: dest.id)
      else
        raise Exceptions::ThatsWeirdError
      end
    end
  end

  def set_merged_id_and_delete
    source.update!(merged_id: dest.id)
    source.reload.soft_delete
  end

  ChildEntity = Struct.new(:child, :dest_id) do
    def merge!
      child.update_columns(:parent_id => dest_id)
    end
  end

  def merge_child_entities
    @child_entities = @source.children.map { |e| ChildEntity.new(e, @dest.id) }
  end

  PartyMember = Struct.new(:party_member, :dest_id) do
    def merge!
      party_member.person.update_columns(party_id: dest_id)
    end
  end

  def merge_party_members
    @party_members = @source.party_members.map { |e| PartyMember.new(e, @dest.id) }
  end

  def merge_cmp_entity
    @cmp_entity = CmpEntity.find_by(entity_id: @source.id)
    if @cmp_entity.present?
      if CmpEntity.exists?(entity_id: @dest.id)
        raise MergingTwoCmpEntitiesError
      else
        @cmp_entity.assign_attributes(entity_id: @dest.id)
      end
    end
  end

  def merge_locations
    @locations = source.locations.map do |location|
      location.tap { |l| l.entity = @dest }
    end
  end

  ## ERRORS ##

  class ExtensionMismatchError < ArgumentError
    def message
      'Only entities with the same primary ext can be merged'
    end
  end

  class EntityMergerError < StandardError; end

  class MergingTwoCmpEntitiesError < EntityMergerError
    def message
      'Both source and dest are a CMP entity. Merging these two is likely a mistake'
    end
  end

  class ConflictingExternalLinksError < EntityMergerError
    def initialize(link_type = 'unknown')
      @link_type = link_type
    end

    def message
      "Both entities have external links of type \"#{@link_type}\" with different values"
    end
  end

  ## Private Methods ##

  private

  def reset_instance_vars
    @extensions = []
    @contact_info = []
    @contact_info_to_delete = []
    @lists = []
    @images = []
    @aliases = []
    @document_ids = []
    @tag_ids = []
    @os_categories = []
    @child_entities = []
    @party_members = []
    @relationships = []
    @potential_duplicate_relationships = []
    @os_match_relationships = []
    @ny_match_relationships = []
    @external_links = []
    @locations = []
  end

  def check_input_validity
    unless source.is_a?(Entity) && dest.is_a?(Entity)
      raise ArgumentError, 'Both source and dest must an Entity'
    end
    raise ExtensionMismatchError unless source.primary_ext == dest.primary_ext
  end

  def set_dest_entity_id
    proc { |x| x.entity_id = dest.id }
  end

  # Set of arrays of three elements: [ entity1_id, entity2_id, category_id ]
  def dest_relationship_lookup
    @dest_relationship_lookup ||= Set.new(dest.relationships.map(&:triplet))
  end
end

# rubocop:enable Rails/Output, Metrics/MethodLength
