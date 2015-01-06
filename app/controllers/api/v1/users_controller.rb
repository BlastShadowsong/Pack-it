class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
    paginate_with @users
  end

  def show
    respond_with @user
  end

  # def create
  #   respond_with 'api_v1', User.create!(user_params)
  # end

  private
  def user_params
    params.require(:user).permit!
  end

  def set_user
    @user = User.find(params[:id])
  end
end
