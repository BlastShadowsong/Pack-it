module Locatable
  module Indoor
    extend ActiveSupport::Concern

    COORDINATE_BOUNDARIES = {min: 0, max: 1000000}

    included do
      include Mongoid::Document

      field :floor, type: Integer
      field :building_uuid, type: String
    end
  end
end