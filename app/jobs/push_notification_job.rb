class PushNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(title, content, user_ids)

    profiles = NotificationProfile.in(user: user_ids)
    return unless profiles.any?

    messages = profiles.map { |np|
      {
          :tokens => [np.device_token],
          :device_type => np.device_type,
          :content => content,
          :title => title
      }
    }
    # messages = NotificationProfile.device_type.values.map { |dt|
    #   {
    #       :tokens => profiles.where(device_type: dt).map(&:device_token),
    #       :device_type => dt,
    #       :content => content,
    #       :title => title
    #   }
    # }

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
