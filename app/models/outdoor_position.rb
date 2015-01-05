class OutdoorPosition
  include Mongoid::Document

  field :latitude, type: Float
  field :longitude, type: Float
  field :altitude, type: Float

  embedded_in :outdoor_locatable, polymorphic: true
end
