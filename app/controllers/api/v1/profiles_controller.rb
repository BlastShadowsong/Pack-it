class Api::V1::ProfilesController < Api::ApplicationController
  before_action :authorize_resource_owner!
  before_action :set_user
  before_action :set_profile, except: [:index]

  def avatar
    content = @profile.picture.read
    if stale?(etag: content, last_modified: @profile.updated_at.utc, public: true)
      send_data content, type: @profile.picture.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end

  def index
    @profiles = @user.profiles
    @profiles = query(@profiles)
    respond_with @profiles
  end

  def show
    respond_with @profile if stale?(@profile)
  end

  def update
    @profile.update!(profile_params)
    # respond_with @profile
    head :no_content
  end

  def add
    key = params[:field]
    value = params[key]
    if @profile[key] && value.is_a?(Array)
      @profile[key] = @profile[key].as_json | value
    else
      @profile[key] = value
    end
    @profile.save!
    head :no_content
  end

  def remove
    key = params[:field]
    value = params[key]
    if @profile[key] && value.is_a?(Array)
      @profile[key] = @profile[key].as_json - value
    else
      @profile[key] = nil
    end
    @profile.save!
    head :no_content
  end

  private
  def profile_params
    params.require(:profile).permit!
  end

  def set_profile
    # @profile = @user.profiles.find_or_initialize_by(_type: params[:type])
    profile_type = params[:type] || params[:profile_type]
    @profile = @user.send(profile_type) if @user.respond_to? profile_type
  end

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id]
    @user = current_user unless @user
  end
end
