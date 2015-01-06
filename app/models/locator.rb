class Locator
  include Mongoid::Document
  include Locatable::Indoor::Point

  field :major, type: Integer
  field :minor, type: Integer
  field :name, type: String

  belongs_to :mall
end
