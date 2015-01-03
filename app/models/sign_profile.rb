class SignProfile < Profile
  include Mongoid::Document

  # last_sign 表示最近登陆的时间
  field :last_sign, type: Timestamps

  embeds_one :outdoor_position, as: :locatable
  embeds_one :indoor_position, as: :locatable
  accepts_nested_attributes_for :outdoor_position, :indoor_position
end