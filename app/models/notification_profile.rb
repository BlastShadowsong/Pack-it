class NotificationProfile < Profile
  include Mongoid::Document

  # after_update :on_updated


  field :seeker_token, type: String
  field :seeker_type
  enumerize :seeker_type, in: [:android, :ios]

  field :solver_token, type: String
  field :solver_type
  enumerize :solver_type, in: [:android, :ios]

  has_and_belongs_to_many :notifications, inverse_of: nil

  def on_updated
    if self.seeker_token_changed?
      title = "登陆已失效"
      content = "请使用新设备"
      device_type = self.device_type_changed? ? self.changes["device_type"][0] : self.device_type
      device_token = self.changes["device_token"][0]
      # SeekerNotificationJob.perform_later(title, content, nil, device_type, [device_token])
    end
  end

end