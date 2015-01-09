class Api::V1::ProfilesController < Api::ApplicationController
  before_action :set_user
  before_action :set_profile, except: [:index]
  
  def index
    @profiles = @user.profiles
    @profiles = @profiles.where(profile_params) if params[:profile].present?
    respond_with @profiles
  end

  def show
    respond_with @profile if stale?(@profile)
  end

  def create
    profile_params.each { |key, value|
      if @profile[key].present? and value.is_a?(Array)
        @profile[key] = @profile[key].as_json | value
      else
        @profile[key] = value
      end
    }
    @profile.save!
    respond_with @profile, status: :no_content
  end

  def update
    @profile.update!(profile_params)
    respond_with @profile
  end

  def destroy
    profile_params.each { |key, value|
      if @profile[key].present? and value.is_a?(Array)
        @profile[key] = @profile[key].as_json - value
      else
        @profile[key] = nil
      end
    }
    @profile.save!
    respond_with @profile
  end

  protected
  def profile_params
    params.require(:profile).permit!
  end

  def set_profile
    @profile = @user.profiles.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id].present?
    @user = current_resource_owner if @user.nil?
  end
end
