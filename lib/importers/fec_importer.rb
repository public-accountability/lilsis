# frozen_string_literal: true

# Transfers FEC data from the sqlite3 fec database to mysql
#   FEC::Candidate --> ExternalData.fec_candidate
#   FEC::Committee --> ExternalData.fec_committee
#   FEC::Donor --> ExternalData.fec_donor
#   FEC::IndividualContribution --> ExternalData.fec_contribution
#
# Importing is done in parallel
module FECImporter
  def self.run
    FEC::Database.establish_connection

    tasks = [:import_candidates, :import_committees, :import_donors, :import_contributions]

    Parallel.each(tasks, in_processes: tasks.length) do |task|
      FEC.logger.info "STARTING #{task}"
      public_send(task)
      FEC.logger.info "FINISHED #{task}"
    end
  end

  def self.import_candidates
    FEC::Candidate.all_candidates.each do |candidate|
      ExternalData.fec_candidate.find_or_initialize_by(dataset_id: candidate.CAND_ID).tap do |ed|
        if should_update?(candidate, ed)
          ed.merge_data(candidate.attributes).save!
          ExternalEntity.fec_candidate.find_or_create_by!(external_data: ed)
        end
      end
    end
  end

  def self.import_committees
    FEC::Committee.order(:FEC_YEAR).find_each do |committee|
      ExternalData.fec_committee.find_or_initialize_by(dataset_id: committee.committee_id).tap do |ed|
        if should_update?(committee, ed)
          ed.merge_data(committee.attributes).save!
          ExternalEntity.fec_committee.find_or_create_by!(external_data: ed)
        end
      end
    end
  end

  def self.import_donors
    FEC::Donor.find_each do |donor|
      ed = ExternalData.fec_donor.find_or_initialize_by(dataset_id: donor.md5digest)

      unless ed.persisted? # remove this to update
        ed.merge_data(donor.nice).save!
      end

      ExternalEntity.fec_donor.find_or_create_by!(external_data: ed)
    end
  end

  def self.import_contributions
    FEC::IndividualContribution.importable_transactions.find_each do |ic|
      ic.import_into_external_data
    end
  end

  private_class_method def self.should_update?(fec_model, external_data)
    return true unless external_data.persisted?
    return true if external_data.data['FEC_YEAR'].blank?

    fec_model.FEC_YEAR >= external_data['FEC_YEAR'].to_i
  end
end
