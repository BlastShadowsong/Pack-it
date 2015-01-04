class CloseQuestWorker
  include Sidekiq::Worker

  def perform(quest_id)
    subject = "quest #{quest_id}"
    logger.info "start CloseQuestWorker for #{subject}"
    quest = Quest.find(quest_id)

    # TODO: warn if already closed
    # logger.warn "#{subject}: already closed!"

    # TODO: close the quest
    logger.info "#{subject}: closed successfully!"
  end
end