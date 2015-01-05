class SocialProfile < Profile
  include Mongoid::Document

  field :name, type: String
  field :avatar, type: String

  field :gender
  enumerize :gender, in: [:male, :female], default: :male

  field :birth_date, type: Date

  def age
    Date.today.year - self.birth_date.year
  end
end
