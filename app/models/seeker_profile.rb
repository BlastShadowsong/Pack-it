class SeekerProfile < Profile
  include Mongoid::Document

  # total 表示发布过的任务总数
  field :total, type: Integer, default: 0
  # finished 表示被完成的任务总数
  field :finished, type: Integer, default: 0
  # failed 表示过期或取消的任务总数
  field :failed, type: Integer, default: 0
  # accepted 表示Seeker反馈为accept的任务总数
  field :accepted, type: Integer, default: 0
  # denied 表示Seeker反馈为deny的任务总数
  field :denied, type: Integer, default: 0
  # credit 表示Seeker消费的积分总数
  field :credit, type: Integer, default: 0

  has_and_belongs_to_many :problems, inverse_of: nil

  def increase_total
    self.inc(total: 1)
  end

  def increase_finished
    self.inc(finished: 1)
  end

  def increase_failed
    self.inc(failed: 1)
  end

  def increase_accepted
    self.inc(accepted: 1)
  end

  def increase_denied
    self.inc(denied: 1)
  end

  def increase_credit(value)
    self.inc(credit: value)
  end
end