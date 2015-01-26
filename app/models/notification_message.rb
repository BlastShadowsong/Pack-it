class NotificationMessage
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  after_create :on_created

  field :title, type: String, default: "您有新的消息："
  field :content, type: String
  field :uri, type: String, default: "problem"


  belongs_to :user

  private
  def on_created
    PushNotificationJob.perform_later(self.title, self.content, self.uri, self.user_id.to_s)
  end
end
