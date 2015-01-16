class Shop < Place
  include Mongoid::Document
  include Trackable


  field :tel, type: String

  alias_method :merchant, :creator

  belongs_to :brand
  has_many :bargains

  validates_presence_of :tel

  alias_method :mall, :building

  rails_admin do
    edit do
      field :area, :serialized
      include_all_fields
    end
  end
end
