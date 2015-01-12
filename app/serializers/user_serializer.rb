class UserSerializer < ActiveModel::Serializer
  attributes :id, :tel, :email, :role, :created_at, :updated_at
end
