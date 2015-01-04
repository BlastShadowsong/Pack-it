class Shop
  include Mongoid::Document

  include Mongoid::Timestamps
  include Trackable

  field :name, type: String
  field :logo, type: String
  field :no, type: String

  embeds_one :indoor_position, as: :locatable
  accepts_nested_attributes_for :indoor_position

  alias_method :merchant, :creator

  belongs_to :business_complex
  belongs_to :brand
  has_many :bargains
end
