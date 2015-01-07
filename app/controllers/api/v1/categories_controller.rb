class Api::V1::CategoriesController < Api::ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = Category.all
    paginate_with @categories
  end

  def show
    respond_with @category if stale?(@category)
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end
end