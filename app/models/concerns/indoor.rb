module Indoor
  extend ActiveSupport::Concern

  COORDINATE_BOUNDARIES = {min: 0, max: 1000000}

  included do
    include Mongoid::Document

    field :floor, type: Integer

    attr_accessor :building
  end

  def building_uuid
    self.building.uuid if self.building
  end

  def building_uuid=(value)
    self.building = value.blank? ? nil : Building.find_by(uuid: value)
  end

end