class UserSerializer < ActiveModel::Serializer
  attributes :id, :tel, :email, :created_at, :updated_at
end
