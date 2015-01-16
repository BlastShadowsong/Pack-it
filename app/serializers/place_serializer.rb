class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :area, :area_points, :floor, :building_uuid, :location
end
