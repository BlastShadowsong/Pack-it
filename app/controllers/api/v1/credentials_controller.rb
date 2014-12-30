class Api::V1::CredentialsController < Api::V1::ApiController
  before_action :doorkeeper_authorize!

  def me
    respond_with current_resource_owner
  end

end
