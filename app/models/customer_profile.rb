class CustomerProfile < Profile
  include Mongoid::Document

  has_and_belongs_to_many :bargains, inverse_of: nil
  has_and_belongs_to_many :tags, inverse_of: nil
end
