class CrowdsourcingProfile < Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :credit, type: Integer
  enumerize :kind,
            in: [:customer, :shopkeeper, :officer],
            default: :customer
end