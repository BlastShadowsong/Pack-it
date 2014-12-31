class Api::V1::ShopsController < Api::V1::ApiController
  before_action :set_business_complex, only: [:index]
  before_action :set_shop, only: [:show]

  def index
    respond_with @business_complex.shops
  end

  def show
    respond_with @shop
  end

  private
  def set_shop
    @shop = Shop.find(params[:id])
  end

  def set_business_complex
    @business_complex = BusinessComplex.find(params[:business_complex_id])
  end
end