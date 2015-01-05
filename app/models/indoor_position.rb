class IndoorPosition
  include Mongoid::Document

  field :x, type: Float
  field :y, type: Float
  field :floor, type: Integer
  field :radius, type: Integer
  field :coordinator, type: String

  embedded_in :indoor_locatable, polymorphic: true


  def min_latitude
    self.latitude - self.radius
  end

  def min_longitude
    self.longitude - self.radius
  end

  def max_latitude
    self.latitude + self.radius
  end

  def max_longitude
    self.longitude + self.radius
  end
end
