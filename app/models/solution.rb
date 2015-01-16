class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  after_create :on_created
  after_update :answer


  field :status
  enumerize :status,
            in: [:unsolved, :solved, :commented, :failed ],
            default: :unsolved

  field :result, type: String

  field :feedback
  enumerize :feedback,
            in: [:uncommented, :accepted, :denied],
            default: :uncommented

  belongs_to :quest

  alias_method :startup, :created_at
  alias_method :solver, :creator

  def kind
    self.quest.kind
  end

  def rank
    self.quest.rank
  end

  def credit
    self.quest.credit
  end

  def duration
    self.quest.duration
  end

  def message
    self.quest.message
  end

  def places
    self.quest.places
  end

  def tag
    self.quest.tag
  end

  def deadline
    self.startup + self.duration * 60
  end

  def answer
    # 修改solution的状态
    self.set(status: :solved)
    self.quest.increase_figure
  end

  def close
    self.set(status: :failed)
    self.creator.solver_profile.increase_failed
  end

  private
  def on_created
    # add itself to solver's favorite solutions
    self.creator.solver_profile.solutions.push(self)
    self.creator.solver_profile.touch(:updated_at)
  end
end