class DistributeQuestJob < ActiveJob::Base
  queue_as :default

  def perform(quest_id)
    quest = Quest.find(quest_id)

    # Step 1: 查询user
    # 支持的最晚时间：前5分钟内（活跃的用户）
    latest_time = Time.now - 5 * 60
    active_solvers = LocationProfile.where({:user.ne => quest.creator, :updated_at.gte => latest_time, building: quest.building})

    distribute_solvers = []
    # 如果places为空，改为向整个mall查询；
    # 如果places不为空，查询location_profile中满足条件的user，取amount个
    if quest.places.empty?
      distribute_solvers += active_solvers
    else
      quest.places.each { |place|
        distribute_solvers += active_solvers.where(:floor => place.floor).geo_spacial(:position.within_polygon => [place.area])
      }
      quest.solutions.each { |solution|
        distribute_solvers.each{|solver|
          if solver.user == solution.creator
            distribute_solvers.delete(solver)
          end
        }
      }
    end

    # Step 2: 分发Solutions
    if distribute_solvers.any?
      distribute_solvers = distribute_solvers.take(quest.amount - quest.solutions.count)
      distribute_solvers.each { |solver|
        solution = quest.solutions.build({status: quest.status, feedback: quest.feedback})
        solution.creator = solver.user
        solution.save!
      }

      # 使用腾讯信鸽进行推送
      user_ids = distribute_solvers.map(&:user_id).as_json
      title = "有新的问题期待您的帮助："
      content = quest.message
      PushNotificationJob.perform_now(title, content, user_ids)
    end

    # Step 3: 重发Solutions
    if quest.solutions.count < quest.amount && quest.status.unsolved?
      DistributeQuestJob.set(wait: waiting_time).perform_later(quest_id.to_s)
    end

  end

  private
  def waiting_time
    2 * 60
  end
end
