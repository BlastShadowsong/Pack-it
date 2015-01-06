module Locatable
  module Indoor
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Geospatial

      field :position, type: Mongoid::Geospatial::Point
      field :radius, type: Float
      field :floor, type: Integer
      field :building, type: String

      spatial_index :position, {min: 0, max: 1000000}
    end
  end
end