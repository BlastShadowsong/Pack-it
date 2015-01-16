class Beacon
  include Mongoid::Document
  include Indoor::Around

  field :major, type: Integer
  field :minor, type: Integer
  field :name, type: String

  belongs_to :building

  validates_presence_of :name, :major, :minor, :building, :floor

end
