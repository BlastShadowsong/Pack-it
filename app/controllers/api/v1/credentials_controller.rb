class Api::V1::CredentialsController < Api::ApplicationController
  before_action :doorkeeper_authorize!

  def me
    respond_with current_resource_owner if stale?(current_resource_owner)
  end

end
