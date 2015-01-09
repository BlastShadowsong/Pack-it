class Api::V1::SocialProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.social_profile
  end
end
