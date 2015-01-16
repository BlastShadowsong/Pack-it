class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :status, :result, :feedback

  has_one :problem
end
