class Solution
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
  field :startup, type: Time
  field :deadline, type: Time
  field :status
  enumerize :status,
            in: [:unsolved, :solved, :commented, :failed ],
            default: :unsolved

  field :message, type: String
  field :answer, type: String

  field :feedback
  enumerize :feedback,
            in: [:uncommented, :accepted, :denied],
            default: :uncommented

  belongs_to :quest

  # TODO: 此处Solver应该标识任务接收者的user_id
  alias_method :solver, :creator
end