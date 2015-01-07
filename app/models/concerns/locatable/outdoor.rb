module Locatable
  module Outdoor
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Geospatial

      field :location, type: Mongoid::Geospatial::Point

      spatial_index :location

      # rails_admin do
      #   edit do
      #     field :location, :serialized
      #     include_all_fields
      #   end
      # end
    end
  end
end