require 'base64'

class Problem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable
  include Outdoor

  extend Enumerize

  after_create :on_created
  after_update :on_updated

  mount_uploader :picture, PictureUploader

  field :duration, type: Integer, default: 5

  field :status
  # commented: has got feedback from the solver
  # failed: no answer or has been closed by seeker
  enumerize :status,
            in: [:waiting, :solved, :failed],
            default: :waiting

  field :description, type: String

  field :figure, type: Integer, default: 0

  has_many :solutions
  belongs_to :tag

  # validates_presence_of :picture

  alias_method :startup, :created_at
  alias_method :seeker, :creator

  default_scope -> { desc(:created_at) }

  def solved_solutions
    self.solutions.where(status: :solved)
  end

  def increase_figure
    self.inc(figure: 1)
    self.touch(:updated_at)
  end

  def deadline
    self.startup + self.duration.minutes
  end

  # def credit_prepared
  #   self.credit * self.amount
  # end
  #
  # def credit_expend
  #   self.credit * self.figure
  # end

  def complete
    #   # step 0: 对Solutions的结果做voting，并将最终结果存入Problem的result中
    #   PhotoRecognitionJob.perform_later(self.id.to_s)
    # step 1: 修改Problem的状态为solved，未完成的Solutions的状态为failed
    self.set(status: :solved)
    self.solutions.each { |solution|
      if solution.status.waiting?
        solution.set(status: :failed)
      end
    }
    #   # step 2: 修改Seeker与Solvers的credit
    #   self.creator.crowdsourcing_profile.decrease_credit(self.credit_expend)
    #   self.creator.crowdsourcing_profile.decrease_prepared_credit(self.credit_prepared)
    #   self.creator.crowdsourcing_profile.touch(:updated_at)
    #   self.creator.crowdsourcing_profile.save
    #   self.solutions.each { |solution|
    #     if solution.status.solved?
    #       solution.creator.crowdsourcing_profile.increase_credit(solution.problem.credit)
    #       solution.creator.crowdsourcing_profile.touch(:updated_at)
    #       solution.creator.crowdsourcing_profile.save
    #     end
    #   }
    # step 3: 修改Seeker_Profile中的 finished + 1 以及积分变化
    #         修改Solver_Profile：如果完成，finished + 1，积分变化；如果失败，failed + 1，积分不变
    self.creator.seeker_profile.increase_finished
    #   self.creator.seeker_profile.increase_credit(self.credit_expend)
    self.creator.seeker_profile.touch(:updated_at)
    self.creator.seeker_profile.save
    self.solutions.each { |solution|
      if solution.status.solved?
        solution.creator.solver_profile.increase_finished
        #       solution.creator.solver_profile.increase_credit(solution.problem.credit)
        solution.creator.solver_profile.touch(:updated_at)
        solution.creator.solver_profile.save
      else
        solution.creator.solver_profile.increase_failed
        solution.creator.solver_profile.touch(:updated_at)
        solution.creator.solver_profile.save
      end
    }
  end

  def clean
    # 从seeker_profile中去掉这个problem
    self.creator.seeker_profile.problems.delete(self)
    self.creator.seeker_profile.touch(:updated_at)
    self.creator.seeker_profile.save
  end

  def close
    # step 1: 修改Problem与相应Solutions中的状态为failed
    self.set(status: :failed)
    self.solutions.each { |solution|
      solution.set(status: :failed)
    }
    # step 2: 修改Seeker_Profile与Solver_Profile中的 failed + 1
    self.creator.seeker_profile.increase_failed
    self.creator.seeker_profile.touch(:updated_at)
    self.creator.seeker_profile.save
    # self.creator.crowdsourcing_profile.decrease_prepared_credit(self.credit_prepared)
    # self.creator.crowdsourcing_profile.touch(:updated_at)
    # self.creator.crowdsourcing_profile.save
    self.solutions.each { |solution|
      solution.creator.solver_profile.increase_failed
      solution.creator.solver_profile.touch(:updated_at)
      solution.creator.solver_profile.save
    }
    #   # step 3: 向Seeker推送结果
    #   seeker_message = Notification.create!({
    #                                             title: "您的问题未解决：",
    #                                             content: self.message,
    #                                             uri: self.to_uri,
    #                                             creator: self.creator
    #                                         })
    #   self.creator.notification_profile.notifications.push(seeker_message)
  end

  def store_suggestion
    if self.tag.name == "包"
      filename = "photos/bag/#{self.id}.png"
    elsif self.tag.name == "帽子"
      filename = "photos/hat/#{self.id}.png"
    elsif self.tag.name == "衬衣"
      filename = "photos/shirt/#{self.id}.png"
    elsif self.tag.name == "鞋子"
      filename = "photos/shoes/#{self.id}.png"
    elsif self.tag.name == "裤子"
      filename = "photos/trousers/#{self.id}.png"
    end
    photo = File.new(filename, "w")
    photo.syswrite(self.picture.read)
    photo.close
  end

  #
  # def comment
  #   # 任务只能取消/重发，用户唯一可以做的修改就是添加feedback
  #   # step 1: 修改Problem与相应Solutions中的status为commented
  #   self.set(status: :commented)
  #   self.solutions.each { |solution|
  #     solution.set(status: :commented)
  #   }
  #   # step 2: 在Seeker_Profile和相应的Solver_Profile中修改 accepted 或 denied + 1
  #   # 如果该用户答案与最终答案一致且用户accept，修改feedback为 accepted，Solver_Profile中 accepted + 1
  #   # 如果该用户答案与最终答案一致且用户denied，修改feedback为 denied，Solver_Profile中 denied + 1
  #   # 如果该用户答案与最终答案不一致且用户accept，修改feedback为 denied，Solver_Profile中 denied + 1
  #   if self.feedback.accepted?
  #     self.creator.seeker_profile.increase_accepted
  #     self.creator.seeker_profile.touch(:updated_at)
  #     self.creator.seeker_profile.save
  #     self.solutions.each { |solution|
  #       if solution.status.solved?
  #         solution.set(feedback: :accepted)
  #         solution.creator.solver_profile.increase_accepted
  #         solution.creator.solver_profile.touch(:updated_at)
  #         solution.creator.solver_profile.save
  #       end
  #     }
  #   end
  #
  #   if self.feedback.denied?
  #     self.creator.seeker_profile.increase_denied
  #     self.creator.seeker_profile.touch(:updated_at)
  #     self.creator.seeker_profile.save
  #     self.solutions.each { |solution|
  #       if solution.status.solved?
  #         solution.set(feedback: :denied)
  #         solution.creator.solver_profile.increase_denied
  #         solution.creator.solver_profile.touch(:updated_at)
  #         solution.creator.solver_profile.save
  #       end
  #     }
  #   end
  # end
  #
  #

  private
  def on_created
    # add itself to seeker's favorite problems
    self.creator.seeker_profile.problems.push(self)
    # update the seeker_profile
    self.creator.seeker_profile.increase_total
    self.creator.seeker_profile.touch(:updated_at)
    self.creator.seeker_profile.save
    #   # increase the prepared_credit
    #   self.creator.crowdsourcing_profile.increase_prepared_credit(self.credit_prepared)
    #   self.creator.crowdsourcing_profile.touch(:updated_at)
    #   self.creator.crowdsourcing_profile.save
    #   # judge rank by the credit
    #   self.judge_rank

    # photo classification
    PhotoRecognitionJob.set(wait: 1.seconds).perform_later(self.id.to_s)
    # distribution
    # DistributeProblemJob.perform_later(self.id.to_s)
    # schedule a job to close itself at deadline
    # CloseProblemJob.set(wait: self.duration.minutes).perform_later(self.id.to_s)
  end

  def on_updated
    # Store this photo
    StorePhotosJob.perform_later(self.id.to_s)

    # # remove wrong solutions
    # self.solutions.each{|solution|
    #   solution.set(status: :failed)
    #   solution.creator.solver_profile.solutions.delete(solution)
    #   self.delete(solution)
    # }
    # self.touch(:updated_at)
    # self.creator.seeker_profile.touch(:updated_at)

    # re-distribute the problem
    DistributeProblemJob.perform_later(self.id.to_s)
    CloseProblemJob.set(wait: self.duration.minutes).perform_later(self.id.to_s)
  end
end