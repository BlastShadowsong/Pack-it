class Api::V1::MallsController < Api::ApplicationController
  before_action :set_city, only: [:index]
  before_action :set_mall, only: [:show]

  def index
    @malls = @city.malls
    @malls = @malls.where(mall_params) if params[:mall]
    paginate_with @malls
  end

  def show
    respond_with @mall if stale?(@mall)
  end

  private
  def mall_params
    params.require(:mall).permit!
  end

  def set_city
    @city = City.find(params[:city_id])
  end

  def set_mall
    @mall = Mall.find(params[:id])
  end
end