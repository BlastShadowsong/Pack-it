class Api::V1::BargainsController < Api::V1::ApiController
  before_action :set_business_complex, only: [:index]
  before_action :set_bargain_tag, only: [:index]
  before_action :set_shop, only: [:index]
  before_action :set_bargain, only: [:show]

  def index
    @bargains = Bargain.all
    @bargains = @business_complex.bargains if @business_complex.present?
    @bargains = @bargain_tag.bargains if @bargain_tag.present?
    @bargains = @shop.bargains if @shop.present?
    @bargains = @bargains.where(bargain_params) if params[:bargain].present?
    respond_with @bargains.desc(:created_at).page(params[:page]).per(params[:size])
  end

  def show
    respond_with @bargain
  end

  private
  def bargain_params
    params.require(:bargain).permit!
  end

  def set_bargain
    @bargain = Bargain.find(params[:id])
  end

  def set_business_complex
    @business_complex = BusinessComplex.find(params[:business_complex_id]) if params[:business_complex_id].present?
  end

  def set_bargain_tag
    @bargain_tag = BargainTag.find(params[:bargain_tag_id]) if params[:bargain_tag_id].present?
  end

  def set_shop
    @shop = Shop.find(params[:shop_id]) if params[:shop_id].present?
  end
end