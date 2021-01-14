# frozen_string_literal: true

# Pages
# GET     /fec/entities/:id/contributions         "explore contributions page"
# GET     /fec/entities/:id/match_contributions   "match contributions page"
# GET     /fec/committies/:fec_id
# GET     /fec/candidates/:fec_id

# Endpoints
# POST    /fec/entities/123/donor_match { external_entity_id:  }
# DELETE  /fec/contribution_unmatch   { sub_id: <SUB_ID> }

# Services/Queries
#
# FECDonorQuery.run(entity)                       "search for potential donors'
# FECDonorMatchService.run(donor_id:, sub_ids:)   "do the matching"
# FECContributionsQuery.run                       "show the matched contributions"
#
class FECController < ApplicationController
  before_action :set_entity, only: %i[contributions match_contributions donor_match]

  def match_contributions
    @donors = FECDonorQuery.run(params[:q] || @entity)
  end

  # required params: donor_id, sub_ids
  def donor_match
    ExternalEntity.find(params[:external_entity_id]).match_with(@entity)
    redirect_to action: :match_contributions
  end

  # def contributions
  #   @contributions = FECContributionsQuery.run(@entity)
  # end

  # def contribution_unmatch
  # end

  # def committee
  # end

  # def candidate
  # end
end
