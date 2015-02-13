class Category
  include Mongoid::Document

  field :name, type: String
  field :icon, type: String

  validates_presence_of :name

  has_many :tags
end
