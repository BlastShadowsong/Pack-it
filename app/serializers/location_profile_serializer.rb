class LocationProfileSerializer < ProfileSerializer
  attributes :location, :position, :position_point, :floor, :building_uuid
end
