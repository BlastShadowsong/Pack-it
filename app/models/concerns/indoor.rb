module Indoor
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document

    field :floor, type: Integer

    attr_accessor :building
  end

  def building_uuid
    self.building.uuid if self.building
  end

  def building_uuid=(value)
    self.building = value.blank? ? nil : Building.find_by(uuid: value.downcase)
  end

end