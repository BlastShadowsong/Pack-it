class NotificationProfile < Profile
  include Mongoid::Document

  # 定义每个用户的推送信息
  # 推送id与user为一对一关系
  # 还可以用来存储推送的记录

  field :device_token, type: String
  field :device_type

  enumerize :device_type, in: [:android, :ios]
end