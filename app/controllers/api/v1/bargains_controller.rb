class Api::V1::BargainsController < Api::ApplicationController
  before_action :set_city, only: [:index]
  before_action :set_mall, only: [:index]
  before_action :set_tag, only: [:index]
  before_action :set_brand, only: [:index]
  before_action :set_shop, only: [:index]
  before_action :set_bargain, only: [:show]

  def index
    @bargains = @city.bargains if @city
    @bargains = @mall.bargains if @mall
    @bargains = @tag.tagged(Bargain) if @tag
    @bargains = @brand.bargains if @brand
    @bargains = @shop.bargains if @shop
    @bargains = Bargain.all unless @bargains
    @bargains = @bargains.where(bargain_params) if params[:bargain]
    paginate_with @bargains.desc(:created_at)
  end

  def show
    respond_with @bargain if stale?(@bargain)
  end

  private
  def bargain_params
    params.require(:bargain).permit!
  end

  def set_bargain
    @bargain = Bargain.find(params[:id])
  end

  def set_city
    @city = City.find(params[:city_id]) if params[:city_id]
  end

  def set_mall
    @mall = Mall.find(params[:mall_id]) if params[:mall_id]
  end

  def set_tag
    @tag = Tag.find(params[:tag_id]) if params[:tag_id]
  end

  def set_brand
    @brand = Brand.find(params[:brand_id]) if params[:brand_id]
  end

  def set_shop
    @shop = Shop.find(params[:shop_id]) if params[:shop_id]
  end
end