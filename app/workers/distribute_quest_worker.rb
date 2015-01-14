class DistributeQuestWorker
  include Sidekiq::Worker

  def perform(quest_id)
    subject = "quest #{quest_id}"
    logger.info "start DistributeQuestWorker for #{subject}"
    quest = Quest.find(quest_id)


    # step 1: 查询business_complex表，获得商家位置，确定分发参数（坐标上下限，人数），支持的最晚时间
    latest_time = Time.now - 5 * 60

    # step 2: 查询location_profile中满足以下条件的用户:
    # location在坐标范围之内
    # updated_at在latest_time之后
    # 排序依据为updated_at降序，取前amount个
    active_solvers = LocationProfile.where(:updated_at.lte => latest_time).ne(user: quest.creator)
    distribute_solvers = []
    quest.shops.each { |shop|
      distribute_solvers += active_solvers.geo_spacial(:position.within_polygon => [shop.area]).where(:floor => shop.floor)
    }
    distribute_solvers = distribute_solvers.take(quest.amount)

    # step 3: 调用solution的create方法，赋给相应的参数，分别创建对应的solution
    distribute_solvers.each { |solver|
      solution = quest.solutions.build({status: quest.status, feedback: quest.feedback})
      solution.creator = solver.user
      solution.save!
    }

    # step 4: 修改Seeker_Profile中 total + 1，各个solution对应的Solver_Profile中 total + 1

    quest.creator.seeker_profile.increase_total

    distribute_solvers.each{ |solver|
      solver.user.solver_profile.increase_total
    }
    # step 5: 使用腾讯信鸽进行推送
    user_id = []
    distribute_solvers.each {|solver|
      user_id += solver.id.to_s
    }
    title = "有新的问题期待您的帮助："
    content = quest.message
    PushNotificationJob.perform_now(user_id, title, content)
  end
end