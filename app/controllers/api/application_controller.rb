class Api::ApplicationController < ActionController::API
  include ActionController::ImplicitRender

  before_action -> { doorkeeper_authorize! :public }, only: [:index, :show]
  before_action -> { doorkeeper_authorize! :write }, only: [:create, :update]
  before_action -> { doorkeeper_authorize! :admin }, only: [:destroy]

  respond_to :json

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
