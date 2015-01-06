class Api::V1::BrandsController < Api::ApplicationController
  def index
    respond_with Brand.all
  end

  def show
    respond_with Brand.find(params[:id])
  end
end