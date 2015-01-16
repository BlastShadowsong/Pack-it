class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Locatable::Indoor::Area

  field :name, type: String
  field :logo, type: String
  field :no, type: String

  belongs_to :building
  has_and_belongs_to_many :tags, inverse_of: nil


  validates_presence_of :name, :logo, :no, :building, :floor

  def location
    self.building.location if self.building
  end
end
