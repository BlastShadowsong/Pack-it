class Mall
  include Mongoid::Document
  include Mongoid::Timestamps
  include Locatable::Outdoor

  field :name, type: String
  field :logo, type: String
  field :maps, type: Array
  field :uuid, type: String
  field :address, type: String

  has_many :beacons
  has_many :passages
  has_many :shops
  belongs_to :city

  validates_presence_of :name

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
