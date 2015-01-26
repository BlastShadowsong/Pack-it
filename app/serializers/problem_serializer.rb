class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :kind, :rank, :credit, :amount, :figure, :duration, :status, :message, :result, :feedback,
             :startup, :deadline

  has_one :building
  has_one :tag
  has_many :places
  has_many :solutions, serializer: SolutionPreviewSerializer
end