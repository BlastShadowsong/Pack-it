class UserMailer < ApplicationMailer

  def otp(id)
    @user = User.find(id)
    @token = @user.otp_code
    mail to: @user.email, subject: "Your One-time password"
  end
end

