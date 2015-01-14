class BeaconSerializer < ActiveModel::Serializer
  attributes :id, :major, :minor, :name, :position, :position_point, :radius, :floor, :building_uuid
end
