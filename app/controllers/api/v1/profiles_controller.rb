class Api::V1::ProfilesController < Api::ApplicationController
  before_action :set_user
  before_action :set_profile, only: [:show, :update]

  def index
    @profiles = @user.profiles
    respond_with Hash[@profiles.map { |el| [el.class.name, el] }]
  end

  def show
    respond_with @profile
  end

  def update
    if @profile.nil?
      @profile = current_resource_owner.profiles.build(profile_params)
      @profile['_type'] = params[:id]
      @profile.save!
    else
      @profile.update!(profile_params)
    end
    respond_with @profile
  end

  private
  def profile_params
    params.require(:profile).permit!
  end

  def set_profile
    @profile = @user.profiles.where(_type: params[:id]).first
  end

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id].present?
    @user = current_resource_owner if @user.nil?
  end
end
