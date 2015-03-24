class DistributeProblemJob < ActiveJob::Base
  queue_as :pack

  def perform(problem_id)
    problem = Problem.find(problem_id)

    # Step 1: 查询user
    # 支持的最晚时间：前5分钟内（活跃的用户）
    # latest_time = Time.now - 5 * 60
    center = problem.location.to_s
    puts center
    distribute_solvers = ShopProfile.where({tag: problem.tag}).geo_near([center]).max_distance(0.1)
    

    # Step 2: 分发Solutions
    if distribute_solvers.any?
      # distribute_solvers = distribute_solvers.take(problem.amount * 2)
      distribute_solvers.each { |solver|
        solution = problem.solutions.build({shop_profile: solver})
        solution.creator = solver.user
        solution.save!

        # 推送
        if solver.user.notification_profile.solver_token.to_s.empty?
        else
          solver_message = Notification.create!({
                                                    receiver: :solver,
                                                    title: "老板，生意上门啦！",
                                                    content: problem.description,
                                                    uri: solution.to_uri,
                                                    creator: solution.creator
                                                })
          solution.creator.notification_profile.notifications.push(solver_message)
        end
      }
    end

    # 更新Problem的updated_at
    problem.touch(:updated_at)
  end

  # private
  # def waiting_time
  #   2 * 60
  # end

end
