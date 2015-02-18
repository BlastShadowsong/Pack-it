class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :status, :price, :description

  has_one :problem, serializer: ProblemPreviewSerializer
end