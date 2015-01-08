class Mall
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable
  include Locatable::Outdoor

  field :name, type: String
  field :logo, type: String
  field :map, type: String
  field :uuid, type: String
  field :address, type: String

  has_many :beacons
  has_many :passages
  has_many :shops
  belongs_to :city

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
