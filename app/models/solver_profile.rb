class SolverProfile < Profile
  include Mongoid::Document

  # total 表示获得过的任务总数
  field :total, type: Integer
  # finished 表示完成的任务总数
  field :finished, type: Integer
  # failed 表示过期、被取消或主动取消（不感兴趣）的任务总数
  field :failed, type: Integer
  # accepted 表示Seeker反馈为accept的任务总数
  field :accepted, type: Integer
  # denied 表示Seeker反馈为deny的任务总数
  field :denied, type: Integer
  # credit 表示该Solver获得的积分总数
  field :credit, type: Integer

  # prefer 表示用户收藏的Solution id
  field :prefer, type: Array(Integer)
end
