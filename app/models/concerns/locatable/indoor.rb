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
    end
  end
end