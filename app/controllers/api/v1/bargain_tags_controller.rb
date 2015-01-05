class Api::V1::BargainTagsController < Api::V1::ApiController
  before_action :set_bargain_tag, only: [:show]

  def index
    @bargain_tags = BargainTag.all
    respond_with @bargain_tags.page(params[:page]).per(params[:size])
  end

  def show
    respond_with @bargain_tag
  end

  private
  def set_bargain_tag
    @bargain_tag = BargainTag.find(params[:id])
  end
end