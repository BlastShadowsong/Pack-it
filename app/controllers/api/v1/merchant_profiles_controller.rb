class Api::V1::MerchantProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.merchant_profile
  end
end
