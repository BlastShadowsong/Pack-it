class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :role, :created_at, :updated_at
end
