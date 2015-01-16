class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon

  has_one :category
end
