class BargainSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_one :shop
  has_many :shopping_tags
end
