class SolverProfile < Profile
  include Mongoid::Document

  # total 表示获得过的任务总数
  field :total, type: Integer, default: 0
  # finished 表示完成的任务总数
  field :finished, type: Integer, default: 0
  # failed 表示过期、被取消或主动取消（不感兴趣）的任务总数
  field :failed, type: Integer, default: 0
  # accepted 表示Seeker反馈为accept的任务总数
  field :accepted, type: Integer, default: 0
  # denied 表示Seeker反馈为deny的任务总数
  field :denied, type: Integer, default: 0
  # credit 表示该Solver获得的积分总数
  field :credit, type: Integer, default: 0

  has_and_belongs_to_many :solutions, inverse_of: nil

  def increase_total
    self.inc(total: 1)
  end
end
