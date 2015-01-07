class CustomerProfileSerializer < ProfileSerializer
  has_many :bargains
  has_many :tags
end
