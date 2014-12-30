class Quest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable
  include RailsAdminConfig
  extend Enumerize

  field :kind
  # TODO: @sy.li, define the enum
  enumerize :kind, in: [:kind_text1, :kind_text2], default: :kind_text1

  field :credit, type: Integer
  field :rank, type: Integer
  field :count, type: Integer
  field :startup, type: Time
  field :deadline, type: Time

  field :status
  # TODO: @sy.li, define the enum
  enumerize :status, in: [:status1, :status2], default: :status1

  field :message, type: String
  field :feedback, type: Integer

  has_many :solutions

  alias_method :seeker, :creator
end