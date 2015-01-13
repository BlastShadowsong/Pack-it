class Shop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable
  include Locatable::Indoor::Area

  field :name, type: String
  field :logo, type: String
  field :no, type: String
  field :tel, type: String

  alias_method :merchant, :creator

  belongs_to :mall
  belongs_to :brand
  has_many :bargains

  has_and_belongs_to_many :tags, inverse_of: nil

  validates_presence_of :name, :logo, :no, :tel

  def location
    self.mall.location if self.mall.present?
  end
end
