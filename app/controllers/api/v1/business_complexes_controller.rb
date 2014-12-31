class Api::V1::BusinessComplexesController < Api::V1::ApiController
  def index
    respond_with BusinessComplex.all
  end

  def show
    respond_with BusinessComplex.find(params[:id])
  end
end