module Locatable
  module Indoor
    module Around
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document
        include Mongoid::Geospatial
        include Locatable::Indoor::Position

        field :radius, type: Float, default: 1

        # field :around, type: Mongoid::Geospatial::Circle, default: [[0, 0], 16]
        #
        # spatial_index :around, COORDINATE_BOUNDARIES
        #
        # rails_admin do
        #   edit do
        #     field :around, :serialized
        #     include_all_fields
        #   end
        # end
      end
    end
  end
end