class Territory
  include Mongoid::Document

  field :name, type: String

  has_many :business_complexes

  def shops
    Shop.in(business_complex_id: business_complexes.map(&:id))
  end

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
