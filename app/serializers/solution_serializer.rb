class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :kind, :rank, :credit, :duration, :status, :message, :result, :feedback
end
