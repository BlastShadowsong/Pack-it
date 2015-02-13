class PushNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(title, content, uri, device_type, device_tokens)
    m = {
        :tokens => device_tokens,
        :device_type => device_type,
        :content => content,
        :title => title,
        :uri => uri
    }
    conn = Bunny.new
    conn.start
    ch = conn.create_channel
    q = ch.queue('ibc.notifications', durable: true, auto_delete: true)
    x = ch.default_exchange


    x.publish(m.to_json, :routing_key => q.name)


    conn.close
  end
end
