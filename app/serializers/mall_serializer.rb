class MallSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :map, :uuid, :address, :location
end
