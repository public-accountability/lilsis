# frozen_string_literal: true

class EntityConnectionsQuery
  PER_PAGE = 10

  def initialize(entity)
    @entity = Entity.entity_for(entity)
    @category_id = nil
    @page = 1
    @per_page = PER_PAGE
    @excluded_ids = nil
  end

  def category(category_id)
    @category_id = category_id&.to_i
    @category_id = nil if @category_id&.zero?

    unless @category_id.nil? || (1..12).cover?(@category_id)
      raise Exceptions::InvalidRelationshipCategoryError
    end

    self
  end

  def exclude(entityIds)
    @excluded_ids = Array.wrap(entityIds) if entityIds
    self
  end

  def page(page)
    @page = page.to_i
    self
  end

  def per(per_amount)
    @per_page = per_amount.to_i
    self
  end

  def run
    query = Entity
              .joins(:links)
              .select('entity.*, link.relationship_id, link.category_id as relationship_category_id')
              .where('link.entity2_id = ?', @entity.id)
              .where(@category_id ? "link.category_id = #{@category_id}" : nil)

    if @excluded_ids.present?
      query = query.where('link.entity1_id NOT IN (?)', @excluded_ids)
    end

    query
      .order(link_count: :desc)
      .page(@page)
      .per(@per_page)
  end

  def to_oligrapher_nodes
    entities = run.to_a
    relationships = Relationship.lookup_table_for(entities.map(&:relationship_id))

    entities.each_with_object({}) do |e, obj|
      unless obj[e.id]
        obj[e.id] = Oligrapher::Node.from_entity(e)
        obj[e.id][:edges] = []
      end

      obj[e.id][:edges].push(Oligrapher.rel_to_edge(relationships[e.relationship_id]))
    end.values
  end
end
