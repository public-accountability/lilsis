# frozen_string_literal: true

class ExternalData
  module Datasets
    class FECCandidate < SimpleDelegator
      def self.import_or_update(fec_candidate)
        ExternalData.fec_candidate.find_or_initialize_by(dataset_id: fec_candidate.CAND_ID).tap do |ed|
          ed.merge_data(candidate.attributes)
          ed.save!
          ed.external_entity || ed.create_external_entity!(dataset: ed.dataset)
        end
      end
    end
  end
end
