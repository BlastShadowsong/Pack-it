class LocationProfileSerializer < ProfileSerializer
  attributes :location, :floor, :building_uuid

  attribute :position_point, key: :position
end
