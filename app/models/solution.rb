class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  after_create :on_created
  after_update :answer

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
  field :result, type: String

  field :feedback
  enumerize :feedback,
            in: [:uncommented, :accepted, :denied],
            default: :uncommented

  belongs_to :quest

  alias_method :startup, :created_at
  alias_method :solver, :creator

  def answer
    # 修改solution的状态
    self.set(status: :solved)
    self.quest.increase_figure
  end

  def close
    self.set(status: :failed)
    self.creator.solver_profile.increase_failed
    # TODO: 需要从Solver_Profile的solutions表中移除
  end

  private
  def on_created
    # add itself to solver's favorite solutions
    self.creator.solver_profile.solutions.push(self)
  end
end