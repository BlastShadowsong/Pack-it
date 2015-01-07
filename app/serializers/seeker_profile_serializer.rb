class SeekerProfileSerializer < ProfileSerializer
  attributes :total, :finished, :failed, :accepted, :denied, :credit

  has_many :quests
end
