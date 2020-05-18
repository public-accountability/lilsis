# frozen_string_literal: true

class ExternalEntitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_external_entity

  # GET /external_entities/:id
  def show
    if @external_entity.matched?
      render 'already_matched'
    end
  end

  # PATCH /external_entities/:id
  def update
    @external_entity.match_with params.require(:entity_id).to_i
    redirect_to action: 'show'
  end

  private

  def set_external_entity
    @external_entity = ExternalEntityPresenter.new(
      ExternalEntity.find(params.fetch(:id))
    )
  end
end