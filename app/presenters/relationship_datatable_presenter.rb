# frozen_string_literal: true

class RelationshipDatatablePresenter
  FIELDS = %w[id entity1_id entity2_id start_date end_date is_current category_id url is_board is_executive amount].freeze

  extend Forwardable
  attr_reader :hash
  def_delegators :@hash, :to_h, :to_hash, :each, :map

  def initialize(relationship)
    @hash = FIELDS.each_with_object({}) do |field, h|
      h[field] = relationship.public_send(field)
    end
  end
end
