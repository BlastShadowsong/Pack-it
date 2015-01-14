module Locatable
  module Indoor
    module Position
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document
        include Mongoid::Geospatial
        include Locatable::Indoor

        field :position, type: Mongoid::Geospatial::Point, default: [0, 0]

        spatial_index :position, COORDINATE_BOUNDARIES

        # rails_admin do
        #   edit do
        #     field :position, :serialized
        #     include_all_fields
        #   end
        # end
      end

      def position_point
        position.to_hash
        # Mongoid::Geospatial::Point.new(position[0], position[1]).to_hash
      end
    end
  end
end