class SendUserOtpSmsJob < ActiveJob::Base
  queue_as :mailers

  def perform(id)
    user = User.find(id)
    tpl_params = {code: user.otp_code, company: 'ibc'}
    puts tpl_params
    ChinaSMS.to(user.tel, tpl_params, tpl_id: 2)
  end
end
