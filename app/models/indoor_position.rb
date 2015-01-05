class IndoorPosition < Position
  include Mongoid::Document

  field :radius, type: Integer
  field :coordinator, type: String

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
