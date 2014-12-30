class Merchant
  include Mongoid::Document

  include Mongoid::Timestamps
  include Trackable
  include RailsAdminConfig

  field :name, type: String
  field :logo, type: String

  embeds_one :position, as: :locatable
  embeds_one :address, as: :addressable
  accepts_nested_attributes_for :position, :address
end
