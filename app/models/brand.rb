class Brand
  include Mongoid::Document

  field :name, type: String
  field :logo, type: String

  has_many :shops
end
