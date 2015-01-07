class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :position, :radius, :floor, :building
end
