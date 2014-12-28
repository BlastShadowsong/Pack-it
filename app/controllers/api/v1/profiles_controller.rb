class Api::V1::ProfilesController < Api::V1::ApiController
  before_action -> { doorkeeper_authorize! :public }, only: :index
  before_action only: [:create, :update, :destroy] do
    doorkeeper_authorize! :admin, :write
  end

  respond_to :json

  def index
    # respond_with Profile.recent
  end

  def create
    # respond_with 'api_v1', Profile.create!(params[:profile])
  end

end
