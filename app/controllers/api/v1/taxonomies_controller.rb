class Api::V1::TaxonomiesController < Api::ApplicationController
  before_action :set_taxonomy, only: [:show]

  def index
    @taxonomies = Taxonomy.all
    paginate_with @taxonomies
  end

  def show
    respond_with @tag if stale?(@tag)
  end

  private
  def set_taxonomy
    @tag = Taxonomy.find(params[:id])
  end
end