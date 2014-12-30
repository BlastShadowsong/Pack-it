class LocationProfile < Profile
  include Mongoid::Document

  embeds_one :position, as: :locatable
  accepts_nested_attributes_for :position
end
