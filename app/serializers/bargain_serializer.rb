class BargainSerializer < ActiveModel::Serializer
  attributes :id, :name, :start, :end, :title, :content, :pictures, :customers_count

  has_one :shop
  has_many :tags
end
