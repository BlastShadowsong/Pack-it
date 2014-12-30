class CrowdsourcingProfile < Profile
  include Mongoid::Document

  field :credit, type: Integer
end
