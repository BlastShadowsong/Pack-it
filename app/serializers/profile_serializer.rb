class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :_type, :created_at, :updated_at
end
