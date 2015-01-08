class Api::V1::CustomerProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.customer_profile
  end
end
