class Api::V1::SolutionsController < Api::V1::ApiController
  before_action :set_quest, only: [:index, :create]

  respond_to :json

  def index
    # TODO: @sy.li, need sorted items
    @solutions = @quest.solutions
    respond_with @solutions
  end

  def create
    @solution = @quest.solutions.build(solution_params)
    @solution.save!
    # TODO: @sy.li, need fire a event for new solution to notify seeker
    respond_with 'api_v1', @solution
  end

  private
  def solution_params
    params.require(:solution).permit!
  end

  def set_quest
    @quest = Quest.find(params[:quest_id])
  end
end