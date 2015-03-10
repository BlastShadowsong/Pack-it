class ProblemPreviewSerializer < ActiveModel::Serializer
  attributes :id, :location, :duration, :status, :description,
             :startup, :deadline

  has_one :picture
  has_one :tag
end