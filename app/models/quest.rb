class Quest
  include Mongoid::Document

  field :seeker, type: Integer
  field :kind, type: Integer
  field :credit, type: Integer
  field :rank, type: Integer
  field :count, type: Integer
  field :startup, type: Time
  field :deadline, type: Time
  field :status, type: Integer
  field :message, type: String
  field :feedback, type: Integer

  has_many :solves

end