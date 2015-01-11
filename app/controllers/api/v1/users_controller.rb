class Api::V1::UsersController < Api::ApplicationController
  skip_before_action :authorize_write, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    paginate_with @users
  end

  def show
    respond_with @user if stale?(@user)
  end

  # sign up/in via otp
  def create
    @user = User.find_or_initialize_by(user_params)
    if @user.new_record?
      render json: @user.errors, status: :unprocessable_entity and return unless @user.save
    end

    @user.send_otp_code
    head :created
  end

  # change password/tel/email
  def update
    @user.attributes = user_params
    tel_changed = @user.tel_changed?
    email_changed = @user.email_changed?
    need_revoke = @user.encrypted_password_changed? || tel_changed || email_changed

    render json: @user.errors, status: :unprocessable_entity and return unless @user.save

    @user.send_otp_code_to_tel if tel_changed
    @user.send_otp_code_to_email if email_changed
    doorkeeper_token.revoke if need_revoke

    respond_with @user
  end

  # TODO: cancel account
  def destroy
  end

  private
  def user_params
    params.require(:user).permit!
  end

  def set_user
    @user = User.find(params[:id]) if params[:id].present?
    @user = current_user if @user.nil?
  end
end
