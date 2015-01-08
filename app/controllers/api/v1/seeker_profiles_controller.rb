class Api::V1::SeekerProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.seeker_profile
  end
end
