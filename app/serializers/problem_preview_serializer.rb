class ProblemPreviewSerializer < ActiveModel::Serializer
  attributes :id, :duration, :status, :description, :picture,
             :startup, :deadline

  has_one :tag
end