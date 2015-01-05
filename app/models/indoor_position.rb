class IndoorPosition
  include Mongoid::Document

  field :x, type: Float
  field :y, type: Float
  field :floor, type: Integer
  field :radius, type: Integer
  field :coordinator, type: String

  embedded_in :indoor_locatable, polymorphic: true


  def min_x
    self.x - self.radius
  end

  def max_x
    self.x + self.radius
  end

  def min_y
    self.y - self.radius
  end

  def max_y
    self.y + self.radius
  end
end
