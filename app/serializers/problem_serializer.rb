class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :duration, :status, :description,
             :startup, :deadline

  has_one :picture
  has_one :tag
  has_many :solved_solutions, serializer: SolutionPreviewSerializer
end