class Quest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  field :kind
  enumerize :kind,
            in: [:sign, :ibeacon, :question, :picture_wall, :treasure_map, :guess_location, :children, :bank],
            default: :question

  # TODO: 添加一个字段，表示是哪一个商家，并且关联到business_complex
  field :rank
  enumerize :rank,
            in: [:green, :blue, :purple, :gold],
            default: :green

  field :credit, type: Integer
  # amount表示分发的数量，count表示实际完成的数量
  field :amount, type: Integer
  field :count, type: Integer, default: 0
  field :startup, type: Time
  field :deadline, type: Time

  field :status
  # commented: has got feedback from the solver
  # failed: no answer or has been closed by seeker
  enumerize :status,
            in: [:unsolved, :solved, :commented, :failed ],
            default: :unsolved

  field :message, type: String

  field :feedback
  enumerize :feedback,
            in: [:uncommented, :accepted, :denied],
            default: :uncommented


  has_many :solutions

  alias_method :seeker, :creator
end