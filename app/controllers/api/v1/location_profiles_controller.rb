class Api::V1::LocationProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.location_profile
  end
end
