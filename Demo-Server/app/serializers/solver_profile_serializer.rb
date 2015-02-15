class SolverProfileSerializer < ProfileSerializer
  attributes :total, :finished, :failed, :accepted, :denied, :credit

  has_many :solutions
end
