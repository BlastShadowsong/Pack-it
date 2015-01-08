class Api::V1::CitiesController < Api::ApplicationController
  before_action :set_city, only: [:show]

  def index
    @cities = City.all
    @cities = @cities.where(city_params) if params[:city].present?
    paginate_with @cities
  end

  def show
    respond_with @city if stale?(@city)
  end

  private
  def city_params
    params.require(:city).permit!
  end

  def set_city
    @city = City.find(params[:id])
  end
end