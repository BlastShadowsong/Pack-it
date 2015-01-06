module Locatable
  module Indoor
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Geospatial

      field :position, type: Mongoid::Geospatial::Point, spatial: true
      field :radius, type: Float
      field :floor, type: Integer
      field :building, type: String

      def min_x
        self.position[0] - self.radius
      end

      def max_x
        self.position[0] + self.radius
      end

      def min_y
        self.position[1] - self.radius
      end

      def max_y
        self.position[1] + self.radius
      end
    end
  end
end