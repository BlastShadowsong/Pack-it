class Api::V1::SolutionsController < Api::V1::ApiController
  before_action :set_quest, only: [:index, :create]

  def index
    # TODO：查询任务在Solver_Profile中完成（还有删除任务，status修改和prefer中删除）
    @solutions = @quest.solutions
    respond_with @solutions
  end

  def create
    # 创建任务在QuestDistributeWorker中完成，Solver不能自己创建任务
    @solution = @quest.solutions.build(solution_params)
    @solution.save!
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