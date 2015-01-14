class UserSignedOnEvent < Event
  include Mongoid::Document

  # FIXME: use new type of position/location
  # embeds_one :outdoor_position, as: :locatable
  # embeds_one :indoor_position, as: :locatable
  # accepts_nested_attributes_for :outdoor_position, :indoor_position

  belongs_to :user
end
