class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :tel, :area, :area_points, :floor, :building_uuid, :location
end
