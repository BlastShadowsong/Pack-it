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
  # amount表示分发的数量，figure表示实际完成的数量
  field :amount, type: Integer, default: 5
  field :figure, type: Integer, default: 0
  field :duration, type: Integer, default: 5

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
  belongs_to :tag
  has_and_belongs_to_many :shops, inverse_of: nil

  validates_presence_of :message

  alias_method :startup, :created_at
  alias_method :seeker, :creator

  def increase_figure
    self.inc(figure: 1)
    if self.figure == self.amount
      self.complete
    end
  end

  def deadline
    self.startup + self.duration * 60
  end

  def credit_expend
    self.credit * self.figure
  end

  def complete
    # step 0: 对Solutions的结果做voting，并将最终结果存入Quest的result中
    # 取出各个solutions中的result
    sentences = []
    self.solutions.each{|solution|
      if solution.status.solved?
        sentences.push(solution.result)
      end
    }
    # 检索所有分词出现的频率
    segments = Hash.new()
    sentences.each{|sentence|
      sentence.each_char { |word|
        if segments.include?(word)
          segments[word] = segments[word] + 1
        else
          segments[word] = 1
        end
      }
    }
    # 去掉出现频率低（不过半数）的分词
    segments.delete_if{|key, value| value < sentences.size/2 + 1}
    # 统计各个sentence包含高频分词的数量
    figure = Hash.new()
    quest_result = sentences[0]
    sentences.each{|sentence|
      figure[sentence] = 0
      segments.each_key { |word|
        if sentence.include?(word)
          figure[sentence] = figure[sentence] + 1
        end
      }
      if figure[sentence] > figure[quest_result]
        quest_result = sentence
      end
    }
    self.set(result: quest_result)
    # TODO: 调用分词函数（in Python），将分词结果存储在与Quest相关联的分词表中
    # self.solutions.each { |solution|
    #   if solution.status.solved?
    #     self.set(result: solution.result)
    #   end
    # }
    # step 1: 修改Quest的状态为solved，未完成的Solutions的状态为failed
    self.set(status: :solved)
    self.solutions.each { |solution|
      if solution.status.unsolved?
        solution.set(status: :failed)
      end
    }
    # step 2: 修改Seeker与Solvers的credit
    self.creator.crowdsourcing_profile.decrease_credit(self.credit_expend)
    self.solutions.each { |solution|
      if solution.status.solved?
        solution.creator.crowdsourcing_profile.increase_credit(solution.credit)
      end
    }
    # step 3: 修改Seeker_Profile中的 finished + 1 以及积分变化
    #         修改Solver_Profile：如果完成，finished + 1，积分变化；如果失败，failed + 1，积分不变
    self.creator.seeker_profile.increase_finished
    self.creator.seeker_profile.increase_credit(self.credit_expend)
    self.solutions.each { |solution|
      if solution.status.solved?
        solution.creator.solver_profile.increase_finished
        solution.creator.solver_profile.increase_credit(solution.credit)
      end
      if solution.status.failed?
        solution.creator.solver_profile.increase_failed
      end
    }
    # step 4: 向Seeker推送结果
    user_id = []
    user_id += self.id.to_s
    title = "您的问题有新的答案："
    content = quest_result
    PushNotificationJob.perform_now(user_id, title, content)
  end

  def close
    # step 1: 修改Quest与相应Solutions中的状态为failed
    self.set(status: :failed)
    self.solutions.each { |solution|
      solution.set(status: :failed)
    }
    # step 2: 修改Seeker_Profile与Solver_Profile中的 failed + 1
    self.creator.seeker_profile.increase_failed
    self.solutions.each { |solution|
      solution.creator.solver_profile.increase_failed
    }
    # step 3: 向Seeker推送结果
    user_id = []
    user_id += self.id.to_s
    title = "很遗憾，您的问题没能得到解决。"
    content = "试试重新描述一下？"
    PushNotificationJob.perform_now(user_id, title, content)
  end

  def comment
    # 任务只能取消/重发，用户唯一可以做的修改就是添加feedback
    # step 1: 修改Quest与相应Solutions中的status为commented
    self.set(status: :commented)
    self.solutions.each { |solution|
      solution.set(status: :commented)
    }
    # step 2: 在Seeker_Profile和相应的Solver_Profile中修改 accepted 或 denied + 1
    # 如果该用户答案与最终答案一致且用户accept，修改feedback为 accepted，Solver_Profile中 accepted + 1
    # 如果该用户答案与最终答案一致且用户denied，修改feedback为 denied，Solver_Profile中 denied + 1
    # 如果该用户答案与最终答案不一致且用户accept，修改feedback为 denied，Solver_Profile中 denied + 1
    if self.feedback.accepted?
      self.creator.seeker_profile.increase_accepted
      self.solutions.each { |solution|
        solution.set(feedback: :accepted)
        solution.creator.solver_profile.increase_accepted
      }
    end

    if self.feedback.denied?
      self.creator.seeker_profile.increase_denied
      self.solutions.each { |solution|
        solution.set(feedback: :denied)
        solution.creator.solver_profile.increase_denied
      }
    end
  end


  private
  def on_created
    # add itself to seeker's favorite quests
    self.creator.seeker_profile.quests.push(self)
    # schedule a job to close itself at deadline
    CloseQuestWorker.perform_at(self.deadline, self.id.to_s)

    # distribution
    DistributeQuestWorker.perform_async(self.id.to_s)
  end

end