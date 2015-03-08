class Api::V1::SolutionsController < Api::ApplicationController
  before_action :authorize_resource_owner!
  before_action :set_problem, only: [:index, :create]
  before_action :set_solution, only: [:show, :update, :destroy]

  def avatar
    content = @solution.picture.read
    if stale?(etag: content, last_modified: @solution.updated_at.utc, public: true)
      send_data content, type: @solution.picture.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end

  def index
    @solutions = @problem.solutions if @problem
    @solutions = current_user.solver_profile.solutions unless @solutions
    @solutions = query(@solutions)
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
    head :unprocessable_entity and return unless @solution.status.waiting?

    @solution.attributes = solution_params
    @solution.answer

    render json: @solution.errors, status: :unprocessable_entity and return unless @solution.save

    respond_with @solution
  end

  def destroy
    @solution.clean
    @solution.close
    respond_with @solution
  end

  private
  def solution_params
    params.require(:solution).permit!
  end

  def set_problem
    @problem = Problem.find(params[:problem_id]) if params[:problem_id]
  end

  def set_solution
    @solution = Solution.find(params[:id])
  end
end