class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  after_create :on_created
  after_update :on_updated

  mount_uploader :picture, PictureUploader

  field :status
  enumerize :status,
            in: [:waiting, :solved, :failed ],
            default: :waiting

  field :price, type: String

  field :description, type: String

  belongs_to :problem

  belongs_to :shop_profile

  alias_method :solver, :creator

  default_scope ->{desc(:created_at)}

  def answer
    # 修改solution的状态
    self.set(status: :solved)
    self.problem.increase_figure
    self.creator.solver_profile.touch(:updated_at)
    self.creator.solver_profile.save
  end

  def clean
    self.creator.solver_profile.solutions.delete(self)
    self.creator.solver_profile.touch(:updated_at)
    self.creator.solver_profile.save
  end

  def close
    if self.status.waiting?
      self.set(status: :failed)
      self.creator.solver_profile.increase_failed
      self.creator.solver_profile.touch(:updated_at)
      self.creator.solver_profile.save
    end
  end

  private
  def on_created
    # add itself to solver's favorite solutions
    self.creator.solver_profile.solutions.push(self)
    self.creator.solver_profile.increase_total
    self.creator.solver_profile.touch(:updated_at)
    self.creator.solver_profile.save
  end

  def on_updated
    # update status
    self.answer
    # 新消息推送
    if self.problem.user.notification_profile.seeker_token.to_s.empty?
    else
      seeker_message = Notification.create!({
                                                receiver: :seeker,
                                                title: "主人，商品找着啦！",
                                                content: self.description,
                                                uri: self.problem.to_uri,
                                                creator: self.problem.user
                                            })
      self.problem.creator.notification_profile.notifications.push(seeker_message)
    end
  end
end