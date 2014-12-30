class Shop
  include Mongoid::Document

  include Mongoid::Timestamps
  include Trackable

  field :name, type: String
  field :logo, type: String

  embeds_one :indoor_position, as: :locatable
  embeds_one :address, as: :addressable
  accepts_nested_attributes_for :indoor_position, :address

  belongs_to :business_complex

  alias_method :merchant, :creator
end
