class CustomerProfile < Profile
  include Mongoid::Document

  has_and_belongs_to_many :bargains, inverse_of: nil
  has_and_belongs_to_many :shopping_tags, inverse_of: nil
end
