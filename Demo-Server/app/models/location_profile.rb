class LocationProfile < Profile
  include Mongoid::Document
  include Outdoor

  default_scope ->{desc(:updated_at)}

end
