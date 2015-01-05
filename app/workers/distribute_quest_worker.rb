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
          :"indoor_position.altitude" => {"$eq" => shop.indoor_position.altitude},
          :"indoor_position.latitude" => {"$gte" => shop.indoor_position.min_latitude, "$lte" => shop.indoor_position.max_latitude},
          :"indoor_position.longitude" => {"$gte" => shop.indoor_position.min_longitude, "$lte" => shop.indoor_position.max_longitude}
      }
      distribute_solvers = distribute_solvers.or(filter)
    }
    distribute_solvers = distribute_solvers.limit(quest.amount)

    # step 3: 调用solution的create函数，赋给相应的参数，分别创建对应的solutions
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
    
    # step 6: 查询user表获取要分发的用户的推送id，使用腾讯信鸽进行分发
    #
    # step 7: 启动timer，当时间到达时调用quest_finish函数
  end
end