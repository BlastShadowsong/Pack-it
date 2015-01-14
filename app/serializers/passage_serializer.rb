class PassageSerializer < ActiveModel::Serializer
  attributes :id, :route, :route_points, :floor, :building_uuid
end
