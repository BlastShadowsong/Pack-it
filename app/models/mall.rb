class Mall < Building
  include Mongoid::Document

  def facilities
    self.places.where(_type: Facility.to_s)
  end

  def shops
    self.places.where(_type: Shop.to_s)
  end

  def bargains
    Bargain.in(shop: shops.map(&:id))
  end

  rails_admin do
    edit do
      exclude_fields :passages, :beacons, :places
    end
  end
end
