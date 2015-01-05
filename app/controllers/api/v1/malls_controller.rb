class Api::V1::MallsController < Api::V1::ApiController
  before_action :set_territory, only: [:index]
  before_action :set_mall, only: [:show]

  def index
    respond_with @territory.malls
  end

  def show
    respond_with @mall
  end

  private
  def set_territory
    @territory = Territory.find(params[:territory_id])
  end

  def set_mall
    @mall = Mall.find(params[:id])
  end
end