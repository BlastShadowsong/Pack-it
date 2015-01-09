class Bargain
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  field :name, type: String
  field :start, type: Time
  field :end, type: Time
  field :title, type: String
  field :content, type: String
  field :pictures, type: Array

  belongs_to :shop
  has_and_belongs_to_many :tags, inverse_of: nil

  def customers
    CustomerProfile.where(bargain_ids: self.id)
  end

  def customers_count
    self.customers.count
  end
end
