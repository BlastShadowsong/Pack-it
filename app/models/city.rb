class City
  include Mongoid::Document

  field :name, type: String

  has_many :buildings


  validates_presence_of :name

  def malls
    self.buildings.where(_type: Mall.to_s)
  end

  def shops
    Shop.in(building: malls.map(&:id))
  end

  def bargains
    Bargain.in(shop: shops.map(&:id))
  end
end
