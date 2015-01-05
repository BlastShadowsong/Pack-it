class Api::V1::TerritoriesController < Api::V1::ApiController
  def index
    respond_with Territory.all
  end

  def show
    respond_with Territory.find(params[:id])
  end
end