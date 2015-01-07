module Locatable
  module Indoor
    module Route
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document
        include Mongoid::Geospatial
        include Locatable::Indoor

        field :route, type: Mongoid::Geospatial::Line, default: [[0, 0], [1, 1]]

        spatial_index :route, COORDINATE_BOUNDARIES

        rails_admin do
          edit do
            field :route, :serialized
            include_all_fields
          end
        end
      end
    end
  end
end