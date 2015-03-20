class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  after_create :on_created

  field :receiver
  enumerize :receiver, in: [:seeker, :solver]

  field :title, type: String, default: "您有新的消息"
  field :content, type: String
  field :uri, type: String, default: "problem"


  private
  def on_created
    if self.receiver.seeker?
      PushNotificationJob.perform_later(
          self.title,
          self.content,
          self.uri,
          self.creator.notification_profile.seeker_type,
          self.creator.notification_profile.seeker_token
      )
    elsif self.receiver.solver?
      PushNotificationJob.perform_later(
          self.title,
          self.content,
          self.uri,
          self.creator.notification_profile.solver_type,
          self.creator.notification_profile.solver_token
      )
    end
  end
end
