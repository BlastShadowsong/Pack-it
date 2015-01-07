class Api::V1::TagsController < Api::ApplicationController
  before_action :set_category, only: [:index]
  before_action :set_tag, only: [:show]

  def index
    @tags = @category.tags if @category.present?
    @tags = Tag.all if @tags.nil?
    paginate_with @tags
  end

  def show
    respond_with @tag if stale?(@tag)
  end

  private
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id].present?
  end
end