class Position
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :latitude, type: Float
  field :longitude, type: Float
  field :altitude, type: Float

  embedded_in :locatable, polymorphic: true
end
