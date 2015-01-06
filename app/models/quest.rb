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
  field :result, type: String

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

  def credit_expend
    self.credit * self.count
  end

  def complete
    # TODO: step 0: 对Solutions的结果做voting，并将最终结果存入Quest的result中

    # step 1: 修改Quest与相应Solutions中的状态为solved
    self.set(status: solved)
    self.solutions.each { |solution|
      solution.set(status: solved)
    }

    # step 2: 修改Seeker与Solvers的credit
    self.creator.crowdsourcing_profile.decrease_credit(self.credit_expend)
    self.solutions.each { |solution|
      solution.creator.crowdsourcing_profile.increase_credit(solution.credit)
    }

    # step 3: 修改Seeker_Profile与Solver_Profile中的 finished + 1 以及积分变化
    self.creator.seeker_profile.increase_finished
    self.creator.seeker_profile.increase_credit(self.credit_expend)
    self.solutions.each { |solution|
      solution.creator.solver_profile.increase_finished
      solution.creator.solver_profile.increase_credit(solution.credit)
    }

    # TODO: step 4: 向Seeker和Solver推送结果
  end

  def fail
    # step 1: 修改Quest与相应Solutions中的状态为failed
    self.set(status: failed)
    self.solutions.each { |solution|
      solution.set(status: failed)
    }
    # step 2: 修改Seeker_Profile与Solver_Profile中的 failed + 1
    self.creator.seeker_profile.increase_failed
    self.solutions.each { |solution|
      solution.creator.solver_profile.increase_failed
    }

    # TODO: step 3: 向Seeker和Solver推送结果
  end

  def feedback
    # 任务只能取消/重发，用户唯一可以做的修改就是添加feedback
    # TODO: 任务评价
    # step 1: 修改Quest的status为commented，feedback为上传的feedback
    #
    # step 2: 在Seeker_Profile的prefer中修改相应的accepted或denied + 1
    #
    # step 3: 找到Quest相关的solution，修改status为commented
    # 如果该用户答案与最终答案一致且用户accept，修改feedback为 accepted，Solver_Profile中 accepted + 1
    # 如果该用户答案与最终答案一致且用户denied，修改feedback为 denied，Solver_Profile中 denied + 1
    # 如果该用户答案与最终答案不一致且用户accept，修改feedback为 denied，Solver_Profile中 denied + 1
  end


  private
  def on_created
    # add itself to seeker's favorite quests
    self.creator.seeker_profile.quests.push(self)
    # schedule a job to close itself at deadline
    CloseQuestWorker.perform_at(self.deadline, self.id)
    # distribution
    DistributeQuestWorker.perform_async(self.id.to_s)
  end
end