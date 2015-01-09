class Api::V1::NotificationProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.notification_profile
  end
end
