class DistributeProblemJob < ActiveJob::Base
  queue_as :ibc

  def perform(problem_id)
    problem = Problem.find(problem_id)

    # Step 1: 查询user
    # 支持的最晚时间：前5分钟内（活跃的用户）
    # latest_time = Time.now - 5 * 60
    active_solvers = LocationProfile.where({:user.ne => problem.creator, building: problem.building})

    distribute_solvers = []
    # 如果places为空，改为向整个mall查询；
    # 如果places不为空，查询location_profile中满足条件的user，取amount个
    if problem.places.empty?
      distribute_solvers += active_solvers
    else
      problem.places.each { |place|
        distribute_solvers += active_solvers.where(:floor => place.floor).geo_spacial(:position.within_polygon => [place.area])
      }
      # 确保不会有重复的分发
      problem.solutions.each { |solution|
        distribute_solvers.each{|solver|
          if solver.user == solution.creator
            distribute_solvers.delete(solver)
          end
        }
      }
    end

    # Step 2: 分发Solutions
    if distribute_solvers.any?
      distribute_solvers = distribute_solvers.take(problem.amount * 2)
      distribute_solvers.each { |solver|
        solution = problem.solutions.build({status: problem.status, feedback: problem.feedback})
        solution.creator = solver.user
        solution.save!
      }

      # 使用腾讯信鸽进行推送
      # user_ids = distribute_solvers.map(&:user_id).as_json
      problem.solutions.each{|solution|
        user_id = solution.creator.id.to_s
        title = "新问题期待您的帮助"
        content = problem.message
        uri = solution.to_uri
        PushNotificationJob.perform_later(title, content, uri, user_id)
      }
    end

    # Step 3: 重发Solutions
    if problem.figure < problem.amount && problem.status.unsolved?
      DistributeProblemJob.set(wait: waiting_time).perform_later(problem_id.to_s)
    end

  end

  private
  def waiting_time
    2 * 60
  end
end
