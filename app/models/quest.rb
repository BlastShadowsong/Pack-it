class Quest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  after_create :on_created

  field :kind
  enumerize :kind,
            in: [:sign, :ibeacon, :question, :picture_wall, :treasure_map, :guess_location, :children, :bank],
            default: :question

  field :rank
  enumerize :rank,
            in: [:green, :blue, :purple, :gold],
            default: :green

  field :credit, type: Integer, default: 0
  # amount表示分发的数量，count表示实际完成的数量
  field :amount, type: Integer, default: 0
  field :count, type: Integer, default: 0
  field :duration, type: Integer

  field :status
  # commented: has got feedback from the solver
  # failed: no answer or has been closed by seeker
  enumerize :status,
            in: [:unsolved, :solved, :commented, :failed],
            default: :unsolved

  field :message, type: String

  field :feedback
  enumerize :feedback,
            in: [:uncommented, :accepted, :denied],
            default: :uncommented

  has_many :solutions
  has_and_belongs_to_many :shops, inverse_of: nil

  alias_method :startup, :created_at
  alias_method :seeker, :creator

  def deadline
    self.startup + self.duration * 60
  end

  private
  def on_created
    # add itself to seeker's favorite quests
    # self.creator.seeker_profile.quests << self
    # self.creator.seeker_profile.save!
    # # schedule a job to close itself at deadline
    # CloseQuestWorker.perform_at(self.deadline, self.id)
    # distribution

    DistributeQuestWorker.perform_async(self.id.to_s)

  end
end