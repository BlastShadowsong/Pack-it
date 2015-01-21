class PushNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(title, content, user_ids)

    profiles = NotificationProfile.in(user: user_ids)
    return unless profiles.any?

    messages = profiles.group_by(&:device_type).map { |k, v|
      {
          :tokens => v.map(&:device_token),
          :device_type => k,
          :content => content,
          :title => title
      }
    }

    conn = Bunny.new
    conn.start
    ch = conn.create_channel
    q = ch.queue("ibc.notifications", durable: true, auto_delete: true)
    x = ch.default_exchange

    messages.each { |m|
      x.publish(m.to_json, :routing_key => q.name)
    }

    conn.close
  end
end
