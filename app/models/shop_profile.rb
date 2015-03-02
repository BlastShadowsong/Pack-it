class ShopProfile < Profile
  include Mongoid::Document
  include Outdoor

  mount_uploader :picture, PictureUploader

  field :name, type: String

  field :address, type: String

  field :description, type: String

  field :tel, type: String

  belongs_to :tag

  validates_presence_of :name
end
