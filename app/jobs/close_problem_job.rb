class CloseProblemJob < ActiveJob::Base
  queue_as :default

  def perform(problem_id)
    subject = "problem #{problem_id}"
    problem = Problem.find(problem_id)

    if problem.status.failed?
      logger.warn "#{subject}: Deadline: already closed!"
    else
      # 判断figure是否为0：为0表示任务失败，调用fail；不为0表示任务完成，调用complete
      if problem.figure == 0
        problem.close
        logger.info "#{subject}: Deadline: failed!"
      else
        problem.complete
        logger.info "#{subject}: Deadline: closed successfully!"
      end
    end
  end
end
