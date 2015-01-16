class Api::V1::SolutionsController < Api::ApplicationController
  before_action :authorize_resource_owner!, only: [:index, :show, :create, :update, :destroy]
  before_action :set_problem, only: [:index, :create]
  before_action :set_solution, only: [:show, :update, :destroy]

  def index
    @solutions = @problem.solutions
    @solutions = @solutions.where(solution_params) if params[:solution]
    paginate_with @solutions.asc(:updated_at)
  end

  def show
    respond_with @solution if stale?(@solution)
  end

  def create
    # 创建任务在DistributeProblemJob中完成，Solver不能自己创建任务
    @solution = @problem.solutions.build(solution_params)
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

  def set_problem
    @problem = Problem.find(params[:problem_id])
  end

  def set_solution
    @solution = Solution.find(params[:id])
  end
end