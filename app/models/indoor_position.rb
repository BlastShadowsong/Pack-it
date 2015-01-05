class IndoorPosition
  include Mongoid::Document

  field :x, type: Float
  field :y, type: Float
  field :floor, type: Integer
  field :radius, type: Integer
  field :coordinator, type: String

  embedded_in :indoor_locatable, polymorphic: true
end
