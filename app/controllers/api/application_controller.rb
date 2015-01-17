class Api::ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ApplicationHelper

  before_action -> { doorkeeper_authorize! :public }, only: [:index, :show]
  before_action -> { doorkeeper_authorize! :write }, only: [:create, :update]
  before_action -> { doorkeeper_authorize! :admin }, only: [:destroy]

  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound do
    head :not_found
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token && doorkeeper_token.resource_owner_id
  end

  alias_method :current_user, :current_resource_owner

  protected
  def authorize_resource_owner!
    unless current_resource_owner
      head :unauthorized
    end
  end
end
