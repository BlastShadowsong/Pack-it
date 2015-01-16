module Indoor
  module Around
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Geospatial
      include Indoor::Position

      field :radius, type: Float, default: 1

      # field :around, type: Mongoid::Geospatial::Circle, default: [[0, 0], 16]
      # spatial_index :around, COORDINATE_BOUNDARIES
    end
  end
end