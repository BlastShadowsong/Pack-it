class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :no, :floor, :building_uuid, :location

  attribute :area_points, key: :area
  attribute :center_point, key: :center
end
