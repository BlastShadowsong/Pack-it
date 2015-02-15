class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :status, :price, :feedback

  has_one :problem, serializer: ProblemPreviewSerializer
end