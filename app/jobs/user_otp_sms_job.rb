class UserOtpSmsJob < ActiveJob::Base
  queue_as :mailers

  def perform(user_id)
    user = User.find(user_id)
    tpl_params = {code: user.otp_code, company: 'PackIt'}
    puts tpl_params
    ChinaSMS.to(user.tel, tpl_params, tpl_id: 2)
  end
end
