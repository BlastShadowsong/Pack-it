class BusinessComplex
  include Mongoid::Document

  include Mongoid::Timestamps
  include Trackable

  field :name, type: String
  field :logo, type: String
  field :map, type: String
  field :uuid, type: String

  embeds_one :outdoor_position, as: :outdoor_locatable
  embeds_one :address, as: :addressable
  accepts_nested_attributes_for :outdoor_position, :address

  has_many :locators
  has_many :shops
  belongs_to :territory

  def bargains
    Bargain.in(shop_id: shops.map(&:id))
  end
end
