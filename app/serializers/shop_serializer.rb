class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :area, :floor, :building_uuid, :location
end
