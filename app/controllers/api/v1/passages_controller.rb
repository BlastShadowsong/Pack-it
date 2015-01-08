class Api::V1::PassagesController < Api::ApplicationController
  before_action :set_mall, only: [:index]

  def index
    respond_with @mall.passages
  end

  private
  def set_mall
    @mall = Mall.find(params[:mall_id])
  end

end