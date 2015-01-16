class BuildingSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :maps, :uuid, :address, :location
end
