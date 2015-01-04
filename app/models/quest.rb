class Quest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  belongs_to :business_complex

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

  field :favorite
  enumerize :favorite,
            in: [:true, :false],
            default: :true

  has_many :solutions

  alias_method :startup, :created_at
  alias_method :seeker, :creator

  def deadline
    self.startup + self.duration * 60
  end

  private
  def on_created
    # add itself to seeker's favorite quests
    self.creator.seeker_profile.quests << self
    self.creator.seeker_profile.save!
    # schedule a job to close itself at deadline
    CloseQuestWorker.perform_at(self.deadline, self.id)
    # distribution
    # TODO: 任务分发

    # setp 1: 查询business_complex表，获得商家位置，确定分发参数（坐标上下限，人数），支持的最晚timestamp
    puts self.business_complex
    # step 3: 查询location_profile中满足以下条件的用户:
    # outdoor_location在经纬度范围之内
    # indoor_location在坐标范围之内
    # timestamp在最晚timestamp之后
    # 排序依据为timestamp降序，取前count个获得相应的用户id
    #
    # step 4: 调用solution的create函数，赋给相应的参数，分别创建对应的solutions
    #
    # step 5: 修改Seeker_Profile中 total + 1，各个solution对应的Solver_Profile中 total + 1
    #
    # step 6: 查询user表获取要分发的用户的推送id，使用腾讯信鸽进行分发
    #
    # step 7: 启动timer，当时间到达时调用quest_finish函数
  end
end