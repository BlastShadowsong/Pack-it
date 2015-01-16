class LocationProfile < Profile
  include Mongoid::Document

  include Locatable::Outdoor
  include Locatable::Indoor::Position

  belongs_to :building

end
