class Shop
  include Mongoid::Document

  include Mongoid::Timestamps
  include Trackable

  field :name, type: String
  field :logo, type: String
  field :no, type: String

  embeds_one :indoor_position, as: :indoor_locatable
  accepts_nested_attributes_for :indoor_position

  alias_method :merchant, :creator

  belongs_to :mall
  belongs_to :brand
  has_many :bargains

  has_and_belongs_to_many :shopping_tags, inverse_of: nil
end
