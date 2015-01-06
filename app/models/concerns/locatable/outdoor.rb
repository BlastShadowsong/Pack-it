module Locatable
  module Outdoor
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Geospatial

      field :location, type: Mongoid::Geospatial::Point, spatial: true
    end
  end
end