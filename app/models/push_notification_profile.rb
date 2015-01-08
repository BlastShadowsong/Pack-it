class PushNotificationProfile < Profile
  include Mongoid::Document

  # TODO: 定义每个用户的推送信息（可使用用户的account）
  # 推送id与user为一对一关系
end