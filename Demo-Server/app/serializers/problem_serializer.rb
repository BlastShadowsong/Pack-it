class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :credit, :amount, :figure, :duration, :status, :picture, :result, :feedback,
             :startup, :deadline

  has_one :tag
  has_many :solved_solutions, serializer: SolutionPreviewSerializer
end