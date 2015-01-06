module Locatable
  module Indoor
    module Circle
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document
        include Mongoid::Geospatial
        include Locatable::Indoor

        field :position, type: Mongoid::Geospatial::Circle, spatial: true
      end
    end
  end
end