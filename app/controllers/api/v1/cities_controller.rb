class Api::V1::CitiesController < Api::ApplicationController
  before_action :set_city, only: [:show]

  def index
    @cities = City.all
    paginate_with @cities
  end

  def show
    respond_with @city if stale?(@city)
  end

  private
  def set_city
    @city = City.find(params[:id])
  end
end