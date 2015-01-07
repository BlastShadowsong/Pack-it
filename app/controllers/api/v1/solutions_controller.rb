class Api::V1::SolutionsController < Api::ApplicationController
  before_action :set_quest, only: [:index, :create]
  before_action :set_solution, only: [:show, :update, :destroy]

  def index
    @solutions = @quest.solutions
    @solutions = @solutions.where(solution_params) if params[:solution].present?
    paginate_with @solutions.asc(:updated_at)
  end

  def show
    respond_with @solution if stale?(@solution)
  end

  def create
    # 创建任务在QuestDistributeWorker中完成，Solver不能自己创建任务
    @solution = @quest.solutions.build(solution_params)
    @solution.save!
    respond_with @solution
  end

  def update
    # Solver可以进行的唯一修改是上传result
    @solution.update!(solution_params)
    respond_with @solution
  end

  def destroy
    @solution.close
    respond_with @solution
  end

  private
  def solution_params
    params.require(:solution).permit!
  end

  def set_quest
    @quest = Quest.find(params[:quest_id])
  end

  def set_solution
    @solution = Solution.find(params[:id])
  end
end