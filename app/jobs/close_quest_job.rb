class CloseQuestJob < ActiveJob::Base
  queue_as :default

  def perform(quest_id)
    subject = "quest #{quest_id}"
    quest = Quest.find(quest_id)

    if quest.status.failed?
      logger.warn "#{subject}: Deadline: quest already closed!"
    else
      # 判断figure是否为0：为0表示任务失败，调用fail；不为0表示任务完成，调用complete
      if quest.figure == 0
        quest.close
        logger.info "#{subject}: Deadline: quest failed!"
      end

      if quest.figure != 0
        quest.complete
        logger.info "#{subject}: Deadline: quest closed successfully!"
      end
    end
  end
end