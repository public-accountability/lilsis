# frozen_string_literal: true

module ExternalDatasetService
  class Iapd < Base
    def self.crd_number?(crd)
      return false if crd.blank? || crd.include?('-')

      /\A\d+\z/.match?(crd)
    end

    def validate_match!
      requies_entity!

      extension = @entity.org? ? :business : :business_person

      if @entity.public_send(extension)&.crd_number&.present?
        msg = "Entity #{@entity.id} already has a crd_number. Cannot match row#{@external_dataset.id}"
        raise InvalidMatchError, msg
      end
    end

    def match
      return :already_matched if @external_dataset.matched?

      validate_match!

      extension = @entity.org? ? 'Business' : 'BusinessPerson'

      ApplicationRecord.transaction do
        if crd_number
          if entity.has_extension?(extension)
            entity.merge_extension extension, crd_number: crd_number.to_i
          else
            entity.add_extension extension, crd_number: crd_number.to_i
          end
        else
          entity.add_extension extension
        end
        external_dataset.update! entity_id: entity.id
      end
    end

    def unmatch
      extension = external_dataset.org? ? 'business' : 'business_person'

      ApplicationRecord.transaction do
        @external_dataset.entity.public_send(extension).update! crd_number: nil
        external_dataset.update! entity_id: nil
      end
    end

    private

    def crd_number
      if @external_dataset.row_data_class&.include? 'IapdAdvisor'
        @external_dataset.row_data.fetch('crd_number')
      elsif @external_dataset.row_data_class&.include? 'IapdOwner'
        owner_key = @external_dataset.row_data.fetch('owner_key')
        return owner_key if self.class.crd_number?(owner_key)
      end
    end
  end
end