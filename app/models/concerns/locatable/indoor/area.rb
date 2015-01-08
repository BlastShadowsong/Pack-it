module Locatable
  module Indoor
    module Area
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document
        include Mongoid::Geospatial
        include Locatable::Indoor

        field :area, type: Mongoid::Geospatial::Polygon, default: [[0, 0], [1, 1], [2, 2]]

        spatial_index :area, COORDINATE_BOUNDARIES

        rails_admin do
          edit do
            field :area, :serialized
            include_all_fields
          end
        end
      end
    end
  end
end