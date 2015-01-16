class Building
  include Mongoid::Document
  include Mongoid::Timestamps
  include Outdoor

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

  rails_admin do
    edit do
      exclude_fields :passages, :beacons, :places
    end
  end
end
