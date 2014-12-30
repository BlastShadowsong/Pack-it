class Address
  include Mongoid::Document

  field :city, type: String
  field :street, type: String

  embedded_in :addressable, polymorphic: true
end
