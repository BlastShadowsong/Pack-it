class Api::ApplicationController < ActionController::API
  include ActionController::ImplicitRender

  before_action :authorize_public, only: [:index, :show]
  before_action :authorize_write, only: [:create, :update]
  before_action :authorize_admin, only: [:destroy]

  respond_to :json

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  alias_method :current_user, :current_resource_owner

  protected
  def authorize_public
    doorkeeper_authorize! :public
  end

  def authorize_write
    doorkeeper_authorize! :write
  end

  def authorize_admin
    doorkeeper_authorize! :admin
  end
end
