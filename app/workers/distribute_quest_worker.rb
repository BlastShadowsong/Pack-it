class DistributeQuestWorker
  include Sidekiq::Worker

  def perform(quest_id)
    subject = "quest #{quest_id}"
    logger.info "start DistributeQuestWorker for #{subject}"
    quest = Quest.find(quest_id)

    # TODO: 任务分发
    # step 1: 查询business_complex表，获得商家位置，确定分发参数（坐标上下限，人数），支持的最晚时间
    latest_time = Time.now - 5 * 60

    # step 2: 查询location_profile中满足以下条件的用户:
    # indoor_location在坐标范围之内
    # updated_at在latest_time之后
    # 排序依据为updated_at降序，取前amount个
    distribute_solvers = LocationProfile.all
    quest.shops.each { |shop|
      filter = {
          :"updated_at" => {"$lte" => latest_time},
          :"indoor_position.floor" => {"$eq" => shop.indoor_position.floor},
          :"indoor_position.x" => {"$gte" => shop.indoor_position.min_x, "$lte" => shop.indoor_position.max_x},
          :"indoor_position.y" => {"$gte" => shop.indoor_position.min_y, "$lte" => shop.indoor_position.max_y}
      }
      distribute_solvers = distribute_solvers.or(filter)
    }
    distribute_solvers = distribute_solvers.limit(quest.amount)

    # step 3: 调用solution的create方法，赋给相应的参数，分别创建对应的solution
    distribute_solvers.each { |solver|
      solution = quest.solutions.build({
                                           kind:quest.kind,
                                           rank:quest.rank,
                                           credit:quest.credit,
                                           duration:quest.duration,
                                           status:quest.status,
                                           message:quest.message,
                                       })
      solution.creator = solver.user
      solution.save!
    }

    # step 4: 修改Seeker_Profile中 total + 1，各个solution对应的Solver_Profile中 total + 1

    # step 5: 使用腾讯信鸽进行推送
  end
end