class LocatorSerializer < ActiveModel::Serializer
  attributes :id, :major, :minor, :name, :position, :radius, :floor, :building
end
