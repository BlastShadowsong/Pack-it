class LocationProfile < Profile
  include Mongoid::Document

  include Locatable::Outdoor
  include Locatable::Indoor::Point

end
