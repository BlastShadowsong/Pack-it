class Api::V1::LocatorsController < Api::V1::ApiController
  before_action :set_business_complex, only: [:index]

  def index
    respond_with @business_complex.locators
  end

  private
  def set_business_complex
    @business_complex = BusinessComplex.find(params[:business_complex_id])
  end

end