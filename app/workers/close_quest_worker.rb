class CloseQuestWorker
  include Sidekiq::Worker

  def perform(quest_id)
    subject = "quest #{quest_id}"
    logger.info "start CloseQuestWorker for #{subject}"
    quest = Quest.find(quest_id)

    if(quest.status.failed?)
      logger.warn "#{subject}: Deadline: quest already closed!"
    end
    # 判断count是否为0：为0表示任务失败，调用fail；不为0表示任务完成，调用complete
    if(quest.count == 0 && quest.status.failed?)
      quest.close
      logger.info "#{subject}: Deadline: quest failed!"
    end

    if(quest.count != 0 && quest.status.failed?)
      quest.complete
      logger.info "#{subject}: Deadline: quest closed successfully!"
    end
  end
end