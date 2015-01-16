class BeaconSerializer < ActiveModel::Serializer
  attributes :id, :major, :minor, :name, :radius, :floor, :building_uuid

  attribute :position_point, key: :position
end
