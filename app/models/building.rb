class Building
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
  has_many :places
  belongs_to :city

  validates_presence_of :name, :city, :address
end
