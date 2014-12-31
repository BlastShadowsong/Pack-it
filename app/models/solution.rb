class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  field :status
  # commented: has got feedback from the solver
  enumerize :status,
            in: [:unsolved, :solved, :commented ],
            default: :unsolved

  field :message, type: String
  field :answer, type: String

  belongs_to :quest
  
  alias_method :solver, :creator
end