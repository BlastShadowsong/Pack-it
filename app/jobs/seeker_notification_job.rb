require 'apns'
class SeekerNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(title, content, uri, device_type, device_token)

    APNS.host='gateway.sandbox.push.apple.com'
    APNS.pem='ckForSeeker.pem'
    APNS.port=2195
    APNS.pass='0987'

    APNS.send_notification(device_token, :alert => title, :badge => 1, :sound => 'default',
                           :other => {:sent => uri})

    # m = {
    #     :tokens => device_tokens,
    #     :device_type => device_type,
    #     :content => content,
    #     :title => title,
    #     :uri => uri
    # }
    # conn = Bunny.new
    # conn.start
    # ch = conn.create_channel
    # q = ch.queue('ibc.notifications', durable: true, auto_delete: true)
    # x = ch.default_exchange
    #
    #
    # x.publish(m.to_json, :routing_key => q.name)
    #
    #
    # conn.close
  end
end
