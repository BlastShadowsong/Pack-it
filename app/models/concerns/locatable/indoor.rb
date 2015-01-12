module Locatable
  module Indoor
    extend ActiveSupport::Concern

    COORDINATE_BOUNDARIES = {min: 0, max: 1000000}

    included do
      include Mongoid::Document

      field :floor, type: Integer
      # field :building_uuid, type: String

      attr_accessor :mall
    end

    def building_uuid
      self.mall.uuid if self.mall.present?
    end

    def building_uuid=(value)
      self.mall = value.blank? ? nil : Mall.find_by(uuid: value)
    end

  end
end