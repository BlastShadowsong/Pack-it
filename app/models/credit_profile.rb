class CreditProfile < Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :credit, type: Integer
end