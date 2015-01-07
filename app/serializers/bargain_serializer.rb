class BargainSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_one :shop
  has_many :tags
end
