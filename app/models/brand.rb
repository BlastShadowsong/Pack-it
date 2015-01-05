class Brand
  include Mongoid::Document

  field :name, type: String
  field :logo, type: String

  has_many :shops

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
