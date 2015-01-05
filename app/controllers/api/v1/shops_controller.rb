class Api::V1::ShopsController < Api::V1::ApiController
  before_action :set_business_complex, only: [:index]
  before_action :set_brand, only: [:index]
  before_action :set_shop, only: [:show]

  def index
    @shops = Shop.all
    @shops = @business_complex.shops if @business_complex.present?
    @shops = @brand.shops if @brand.present?
    @shops = @shops.where(shop_params) if params[:shop].present?
    respond_with @shops.desc(:created_at).page(params[:page]).per(params[:page_size])
  end

  def show
    respond_with @shop
  end

  private
  def shop_params
    params.require(:shop).permit!
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def set_business_complex
    @business_complex = BusinessComplex.find(params[:business_complex_id]) if params[:business_complex_id].present?
  end

  def set_brand
    @brand = Brand.find(params[:brand_id]) if params[:brand_id].present?
  end
end