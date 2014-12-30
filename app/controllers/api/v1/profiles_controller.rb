class Api::V1::ProfilesController < Api::V1::ApiController
  before_action :set_user
  before_action :set_profile, only: [:show, :update]

  def index
    @profiles = @user.profiles
    respond_with Hash[@profiles.map { |el| [el.class.name, el] }]
  end

  def show
    respond_with @profile
  end

  def create
    @profile = @user.profiles.build(profile_params)
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
    @profile = @user.profiles.where(_type: params[:id]).first
  end

  def set_user
    @user = params[:user_id].present? ? User.find(params[:user_id]) : current_resource_owner
  end
end
