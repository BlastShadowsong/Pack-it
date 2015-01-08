class BeaconSerializer < ActiveModel::Serializer
  attributes :id, :major, :minor, :name, :position, :radius, :floor, :building_uuid
end
