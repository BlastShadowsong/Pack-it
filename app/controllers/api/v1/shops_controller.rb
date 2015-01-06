class Api::V1::ShopsController < Api::ApplicationController
  before_action :set_city, only: [:index]
  before_action :set_mall, only: [:index]
  before_action :set_shopping_tag, only: [:index]
  before_action :set_brand, only: [:index]
  before_action :set_shop, only: [:show]

  def index
    @shops = Shop.all
    @shops = @city.shops if @city.present?
    @shops = @mall.shops if @mall.present?
    @shops = @shopping_tag.shops if @shopping_tag.present?
    @shops = @brand.shops if @brand.present?
    @shops = @shops.where(shop_params) if params[:shop].present?
    paginate_with @shops.desc(:created_at)
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

  def set_city
    @city = City.find(params[:city_id]) if params[:city_id].present?
  end

  def set_mall
    @mall = Mall.find(params[:mall_id]) if params[:mall_id].present?
  end

  def set_shopping_tag
    @shopping_tag = ShoppingTag.find(params[:shopping_tag_id]) if params[:shopping_tag_id].present?
  end

  def set_brand
    @brand = Brand.find(params[:brand_id]) if params[:brand_id].present?
  end
end