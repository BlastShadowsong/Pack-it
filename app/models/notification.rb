class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  # after_create :on_created

  field :title, type: String, default: "您有新的消息："
  field :content, type: String
  field :uri, type: String, default: "problem"


  private
  def on_created
    PushNotificationJob.perform_later(
        self.title,
        self.content,
        self.uri,
        self.creator.notification_profile.device_type,
        [self.creator.notification_profile.device_token]
    )
  end
end
