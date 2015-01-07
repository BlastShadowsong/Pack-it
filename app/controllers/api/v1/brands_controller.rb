class Api::V1::BrandsController < Api::ApplicationController
  before_action :set_brand, only: [:show]

  def index
    @brands = Brand.all
    paginate_with @brands
  end

  def show
    respond_with @brand if stale?(@brand)
  end

  private
  def set_brand
    @brand = Brand.find(params[:id])
  end
end