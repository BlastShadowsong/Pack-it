class Territory
  include Mongoid::Document

  field :name, type: String

  has_many :malls

  def shops
    Shop.in(mall_id: malls.map(&:id))
  end

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
