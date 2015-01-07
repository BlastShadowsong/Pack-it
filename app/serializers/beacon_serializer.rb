class BeaconSerializer < ActiveModel::Serializer
  attributes :id, :major, :minor, :name, :around, :floor, :building_uuid
end
