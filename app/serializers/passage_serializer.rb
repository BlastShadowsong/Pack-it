class PassageSerializer < ActiveModel::Serializer
  attributes :id, :floor, :building_uuid

  attribute :route_points, key: :route
end
