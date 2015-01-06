class Api::V1::LocatorsController < Api::V1::ApiController
  before_action :set_mall, only: [:index]

  def index
    respond_with @mall.locators
  end

  private
  def set_mall
    @mall = Mall.find(params[:mall_id])
  end

end