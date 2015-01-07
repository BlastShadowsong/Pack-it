class Bargain
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  field :name, type: String

  belongs_to :shop
  has_and_belongs_to_many :tags, inverse_of: nil
end
