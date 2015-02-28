class SolutionPreviewSerializer < ActiveModel::Serializer
  attributes :id, :status, :price, :description

  has_one :picture
end
