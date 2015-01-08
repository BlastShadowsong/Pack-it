class Api::V1::SolverProfilesController < Api::V1::ProfilesController

  private
  def set_profile
    @profile = @user.solver_profile
  end
end
