class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :kind, :rank, :credit, :duration, :status, :message, :result, :feedback, :deadline

  has_one :problem
end
