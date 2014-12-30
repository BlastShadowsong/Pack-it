class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  field :status
  # TODO: @sy.li, define the enum
  enumerize :status, in: [:status1, :status2], default: :status1

  field :message, type: String
  field :answer, type: String

  belongs_to :quest
  
  alias_method :solver, :creator
end