# frozen_string_literal: true

# Creates or finds existing relationship between
# an Iapd Owner and Iapd Advisor
#
# result can be one of these possible symbols:
#  - advisor_not_matched
#  - owner_not_matched
#  - relationship_exists
#  - relationship_created
#
class IapdRelationshipService
  IAPD_TAG_ID = 18

  attr_reader :advisor, :owner, :dry_run, :result, :relationship

  def initialize(advisor:, owner:, dry_run: false)
    @advisor = advisor
    @owner = owner
    @dry_run = dry_run

    if advisor.unmatched?
      @result = :advisor_not_matched
    elsif owner.unmatched?
      @owner.add_to_matching_queue
      @result = :owner_not_matched
    elsif relationship_exists?
      @result = :relationship_exists
    else
      create_relationship unless @dry_run
      @result = :relationship_created
    end

    freeze
  end

  private

  # Checks if a proper relationship exists between the advisor and owner
  # sets @relationships
  # return Boolean
  def relationship_exists?
    @relationship = self.class.find_relationship(advisor: @advisor, owner: @owner)
    @relationship.present?
  end

  # creates and returns relationship
  # sets @relationship
  def create_relationship
    @relationship = self.class.create_relationship(advisor: @advisor, owner: @owner)
  end

  # Class Methods

  # Creates relationship between adivsor and owner
  # Makes a few assumptions:
  #  - No duplicate check is done. Use `find_relationship` to find existing relationship
  #  - The owner must be  matched. Use `owner.matched?` to verify
  #  - The owner is a person and from schedule A
  #    Schedule B contains itermediate relationships, which aren't not yet handled
  #
  #  returns <Relationship>
  def self.create_relationship(advisor:, owner:)
    error! 'Invalid advisor or owner type' unless advisor.advisor? && owner.owner?
    error! 'Owner is not matched' unless owner.matched?
    error! 'Owner is an org' if owner.org?

    filing = owner.latest_filing_for_advisor(advisor.row_data.fetch('crd_number'))

    if filing.nil? || filing.fetch('schedule') == 'B'
      error! "No suitable filing found for #{owner.id}"
    end

    if ('A'..'E').include?(filing.fetch('ownership_code'))
      Rails.logger.info('IapdRelationshipService') { "IapdOwner #{owner.id} is an owner (#{filing.fetch('ownership_code')}) of IapdAdvisor #{advisor.id}" }
    end

    create_position_relationship advisor: advisor, owner: owner, filing: filing
  end

  def self.create_position_relationship(advisor:, owner:, filing:)
    attributes = { category_id: Relationship::POSITION_CATEGORY,
                   entity: owner.entity,
                   related: advisor.entity,
                   start_date: LsDate.convert(filing.fetch('acquired')),
                   description1: filing.fetch('title_or_status') }

    Relationship.create!(attributes).tap do |r|
      r.add_tag IAPD_TAG_ID
      r.add_reference IapdDatum.document_attributes_for_form_adv_pdf(advisor.row_data.fetch('crd_number'))
    end
  end

  # placeholder function for creating ownership relationship
  def self.create_ownership_relationship(advisor:, owner:, filing:)
    raise NotImplementedError
  end

  # Returns relationship between advisor and owner (if one exists)
  # otherwise returns nil
  def self.find_relationship(advisor:, owner:)
    Relationship
      .includes(:taggings)
      .where(entity: owner.entity, related: advisor.entity, category_id: Relationship::POSITION_CATEGORY)
      .to_a
      .find { |r| r.taggings.map(&:tag_id).include?(IAPD_TAG_ID) }
  end

  def self.create_relationships_for(advisor, dry_run: false)
    raise TypeError unless advisor.advisor?

    advisor.owners.map do |owner|
      new advisor: advisor, owner: owner, dry_run: dry_run
    end
  end

  private_class_method def self.error!(msg)
    raise IapdRelationshipError, "[IapdRelationshipService] #{msg}"
  end

  class IapdRelationshipError < Exceptions::LittleSisError; end
end