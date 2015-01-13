class Brand
  include Mongoid::Document

  field :name, type: String
  field :logo, type: String


  validates_presence_of :name

  has_many :shops

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
