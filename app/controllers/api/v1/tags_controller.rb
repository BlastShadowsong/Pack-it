class Api::V1::TagsController < Api::ApplicationController
  before_action :set_taxonomy, only: [:index]
  before_action :set_tag, only: [:show]

  def index
    @tags = @taxonomy.tags if @taxonomy.present?
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

  def set_taxonomy
    @taxonomy = Taxonomy.find(params[:taxonomy_id]) if params[:taxonomy_id].present?
  end
end