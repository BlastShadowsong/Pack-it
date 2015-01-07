class CustomerProfileSerializer < ProfileSerializer
  has_many :bargains
  has_many :shopping_tags
end
