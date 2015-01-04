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
  field :duration, type: Integer

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

  field :favorite
  enumerize :favorite,
            in: [:true, :false],
            default: :true

  belongs_to :quest
  belongs_to :solver_profile

  alias_method :startup, :created_at
  alias_method :solver, :creator
end