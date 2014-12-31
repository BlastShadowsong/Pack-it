class Quest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  field :kind
  enumerize :kind,
            in: [:sign, :ibeacon, :question, :picture_wall, :treasure_map, :guess_location, :children, :bank],
            default: :question

  field :rank
  enumerize :rank,
            in: [:green, :blue, :purple, :gold],
            default: :green

  field :credit, type: Integer
  field :count, type: Integer
  field :startup, type: Time
  field :deadline, type: Time

  field :status
  # commented: has got feedback from the solver
  enumerize :status,
            in: [:unsolved, :solved, :commented ],
            default: :unsolved

  field :message, type: String
  field :feedback, type: Integer

  has_many :solutions

  alias_method :seeker, :creator
end