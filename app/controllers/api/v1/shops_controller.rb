class Api::V1::ShopsController < Api::ApplicationController
  before_action :set_city, only: [:index]
  before_action :set_mall, only: [:index]
  before_action :set_tag, only: [:index]
  before_action :set_brand, only: [:index]
  before_action :set_shop, only: [:show]

  def index
    @shops = @city.shops if @city.present?
    @shops = @mall.shops if @mall.present?
    @shops = @tag.tagged(Shop) if @tag.present?
    @shops = @brand.shops if @brand.present?
    @shops = Shop.all if @shops.nil?
    @shops = @shops.where(shop_params) if params[:shop].present?
    paginate_with @shops.desc(:created_at)
  end

  def show
    respond_with @shop if stale?(@shop)
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

  def set_tag
    @tag = Tag.find(params[:tag_id]) if params[:tag_id].present?
  end

  def set_brand
    @brand = Brand.find(params[:brand_id]) if params[:brand_id].present?
  end
end