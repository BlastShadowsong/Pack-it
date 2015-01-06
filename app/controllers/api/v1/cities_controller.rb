class Api::V1::CitiesController < Api::V1::ApiController
  def index
    respond_with City.all
  end

  def show
    respond_with City.find(params[:id])
  end
end