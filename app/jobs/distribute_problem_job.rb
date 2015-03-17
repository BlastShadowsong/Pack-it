class DistributeProblemJob < ActiveJob::Base
  queue_as :pack

  def perform(problem_id)
    problem = Problem.find(problem_id)

    # Step 1: 查询user
    # 支持的最晚时间：前5分钟内（活跃的用户）
    # latest_time = Time.now - 5 * 60
    distribute_solvers = ShopProfile.where({tag: problem.tag})

    # distribute_solvers = []
    # 如果places为空，改为向整个mall查询；
    # 如果places不为空，查询location_profile中满足条件的user，取amount个


    # Step 2: 分发Solutions
    if distribute_solvers.any?
      # distribute_solvers = distribute_solvers.take(problem.amount * 2)
      distribute_solvers.each { |solver|
        solution = problem.solutions.build({shop_profile: solver})
        solution.creator = solver.user
        solution.save!

        # 推送
        solver_message = Notification.create!({
                                                  title: "生意上门啦！",
                                                  content: problem.description,
                                                  uri: solution.to_uri,
                                                  creator: solution.creator
                                              })
        solution.creator.notification_profile.notifications.push(solver_message)
      }
    end
  end

  # private
  # def waiting_time
  #   2 * 60
  # end

end
