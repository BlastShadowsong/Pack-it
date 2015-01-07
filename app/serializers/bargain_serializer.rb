class BargainSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :shopping_tags
end
