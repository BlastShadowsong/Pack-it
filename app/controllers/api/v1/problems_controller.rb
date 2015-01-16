class Api::V1::ProblemsController < Api::ApplicationController
  before_action :authorize_resource_owner!, only: [:index, :show, :create, :update, :destroy]
  before_action :set_problem, only: [:show, :update, :destroy]


  def index
    @problems = Problem.all
    @problems = @problems.where(problem_params) if params[:problem]
    paginate_with @problems.desc(:created_at)
  end

  def show
    respond_with @problem if stale?(@problem)
  end

  def create
    @problem = Problem.create!(problem_params)
    respond_with @problem
  end

  def update
    if @problem.status.solved?
      @problem.update!(problem_params)
      @problem.comment
    end
    respond_with @problem
  end

  def destroy
    @problem.close
    respond_with @problem
  end


  private
  def problem_params
    params.require(:problem).permit!
  end

  def set_problem
    @problem = Problem.find(params[:id])
  end

end
