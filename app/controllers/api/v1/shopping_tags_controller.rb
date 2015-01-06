class Api::V1::ShoppingTagsController < Api::V1::ApiController
  before_action :set_shopping_tag, only: [:show]

  def index
    @shopping_tags = ShoppingTag.all
    paginate_with @shopping_tags
  end

  def show
    respond_with @shopping_tag
  end

  private
  def set_shopping_tag
    @shopping_tag = ShoppingTag.find(params[:id])
  end
end