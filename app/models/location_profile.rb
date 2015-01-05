class LocationProfile < Profile
  include Mongoid::Document

  embeds_one :outdoor_position, as: :outdoor_locatable
  embeds_one :indoor_position, as: :indoor_locatable
  accepts_nested_attributes_for :outdoor_position, :indoor_position
end
