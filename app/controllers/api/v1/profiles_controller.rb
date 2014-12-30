class Api::V1::ProfilesController < Api::V1::ApiController
  before_action -> { doorkeeper_authorize! :public }, only: [:index, :show]
  before_action -> { doorkeeper_authorize! :admin, :write }, only: [:create, :update, :destroy]

  before_action :set_profile, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @profiles = current_resource_owner.profiles
    respond_with Hash[@profiles.map { |el| [el.class.name, el] }]
  end

  def show
    respond_with @profile
  end

  def create
    @profile = current_resource_owner.profiles.build(profile_params)
    @profile.save!
    respond_with 'api_v1', @profile
  end

  def update
    @profile.update!(profile_params)
    respond_with 'api_v1', @profile
  end

  private
  def profile_params
    params.require(:profile).permit!
  end

  def set_profile
    @profile = current_resource_owner.profiles.where(_type: params[:id]).first
  end
end
