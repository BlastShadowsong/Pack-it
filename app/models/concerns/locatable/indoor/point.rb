module Locatable
  module Indoor
    module Point
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document
        include Mongoid::Geospatial
        include Locatable::Indoor

        field :position, type: Mongoid::Geospatial::Point, spatial: true
      end
    end
  end
end