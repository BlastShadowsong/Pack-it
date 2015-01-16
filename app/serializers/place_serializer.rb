class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :area, :area_points, :center_point, :floor, :building_uuid, :location
end
