class ProfileSerializer < ActiveModel::Serializer
  attributes :created_at, :updated_at

  attribute :_type, key: :type
end
