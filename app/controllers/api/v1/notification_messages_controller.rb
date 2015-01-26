class Api::V1::NotificationMessagesController < Api::ApplicationController
  before_action :authorize_resource_owner!, only: [:index, :destroy]
  before_action :set_notification_message, only: [:destroy]

  def index
    @notification_messages = current_user.notification_messages
    paginate_with @notification_messages.desc(:created_at)
  end

  def destroy
    @notification_message.destroy
    respond_with @notification_message
  end

  private
  def set_notification_message
    @notification_message = NotificationMessage.find(params[:id])
  end
end
