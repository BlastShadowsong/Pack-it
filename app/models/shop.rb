class Shop < Place
  include Mongoid::Document
  include Trackable

  field :tel, type: String

  alias_method :merchant, :creator

  belongs_to :brand
  has_many :bargains

  validates_presence_of :tel

  alias_method :mall, :building
end
