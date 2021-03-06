class Api::V1::ProblemsController < Api::ApplicationController
  before_action :authorize_resource_owner!
  before_action :set_problem, only: [:show, :update, :destroy]

  def avatar
    content = @problem.picture.read
    if stale?(etag: content, last_modified: @problem.updated_at.utc, public: true)
      send_data content, type: @problem.picture.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end

  def index
    @problems = current_user.seeker_profile.problems
    @problems = query(@problems)
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
    @problem.update!(problem_params)

    respond_with @problem
  end

  def destroy
    @problem.clean
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
