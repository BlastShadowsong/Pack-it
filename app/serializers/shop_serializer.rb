class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :tel, :area, :floor, :building_uuid, :location
end
