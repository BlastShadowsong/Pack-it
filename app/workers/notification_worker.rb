class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_id)
    # subject = "notification #{notification_id}"
    # logger.info "start worker for #{subject}"
    # notification = Notification.find(notification_id)
    # if notification.nil?
    #   logger.error "#{subject}: not found!"
    # elsif notification.state.success?
    #   logger.warn "#{subject}: already done successfully!"
    # else
    #   subject = "#{subject} for #{notification.subscription.label}"
    #   notification.deliver
    #   logger.info "#{subject}: #{notification.state}!"
    #   if notification.state.failed?
    #     raise "#{subject}: #{notification.state}!"
    #   end
    # end
  end
end