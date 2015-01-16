class LocationProfile < Profile
  include Mongoid::Document
  include Outdoor
  include Indoor::Position

  belongs_to :building

end
