class Position
  include Mongoid::Document

  field :latitude, type: Float
  field :longitude, type: Float
  field :altitude, type: Float
  field :coordinator, type: String

  embedded_in :locatable, polymorphic: true
end
