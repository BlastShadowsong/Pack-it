class PushNotificationToDeviceJob < ActiveJob::Base
  queue_as :mailers

  def perform(title, content, device_type, device_token)
    m = {
        :tokens => [device_token],
        :device_type => device_type,
        :content => content,
        :title => title
    }
    conn = Bunny.new
    conn.start
    ch = conn.create_channel
    q = ch.queue("ibc.notifications", durable: true, auto_delete: true)
    x = ch.default_exchange


    x.publish(m.to_json, :routing_key => q.name)


    conn.close
  end
end
