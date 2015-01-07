class PassageSerializer < ActiveModel::Serializer
  attributes :id, :route, :floor, :building_uuid
end
