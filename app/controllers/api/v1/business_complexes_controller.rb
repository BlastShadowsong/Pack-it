class Api::V1::BusinessComplexesController < Api::V1::ApiController
  before_action :set_territory, only: [:index]
  before_action :set_business_complex, only: [:show]

  def index
    respond_with @territory.business_complexes
  end

  def show
    respond_with @business_complex
  end

  private
  def set_territory
    @territory = Territory.find(params[:territory_id])
  end

  def set_business_complex
    @business_complex = BusinessComplex.find(params[:id])
  end
end