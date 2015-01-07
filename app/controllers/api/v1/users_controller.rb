class Api::V1::UsersController < Api::ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
    paginate_with @users
  end

  def show
    respond_with @user if stale?(@user)
  end

  # TODO: user registration
  # def create
  #   respond_with User.create!(user_params)
  # end

  private
  def user_params
    params.require(:user).permit!
  end

  def set_user
    @user = User.find(params[:id])
  end
end
