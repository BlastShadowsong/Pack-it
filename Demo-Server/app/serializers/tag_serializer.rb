class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon, :logo

  has_one :category
end
