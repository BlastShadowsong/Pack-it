class Mall < Building
  include Mongoid::Document

  def shops
    self.places.where(_type: Shop.to_s)
  end

  def bargains
    Bargain.in(shop: shops.map(&:id))
  end
end
