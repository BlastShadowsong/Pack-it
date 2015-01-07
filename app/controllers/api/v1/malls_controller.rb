class Api::V1::MallsController < Api::ApplicationController
  before_action :set_city, only: [:index]
  before_action :set_mall, only: [:show]

  def index
    respond_with @city.malls
  end

  def show
    respond_with @mall if stale?(@mall)
  end

  private
  def set_city
    @city = City.find(params[:city_id])
  end

  def set_mall
    @mall = Mall.find(params[:id])
  end
end