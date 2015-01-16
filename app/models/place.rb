class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Indoor::Area

  field :name, type: String
  field :logo, type: String
  field :no, type: String

  belongs_to :building
  has_and_belongs_to_many :tags, inverse_of: nil


  validates_presence_of :name, :logo, :no, :building, :floor

  def location
    self.building.location if self.building
  end

  rails_admin do
    edit do
      field :area, :serialized
      include_all_fields
    end
  end
end
