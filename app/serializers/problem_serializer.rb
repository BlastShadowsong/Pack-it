class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :duration, :status, :description, :picture,
             :startup, :deadline

  has_one :tag
  has_many :solved_solutions, serializer: SolutionPreviewSerializer
end