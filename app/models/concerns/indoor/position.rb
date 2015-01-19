module Indoor
  module Position
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Geospatial
      include Indoor

      field :position, type: Mongoid::Geospatial::Point, default: [0, 0]

      spatial_index :position
    end

    def position_point
      position.to_hash
    end
  end
end