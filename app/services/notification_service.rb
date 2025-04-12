class NotificationService
  attr_reader :user, :notification_params, :errors

  def initialize(user, notification_params)
    @user = user
    @notification_params = notification_params
    @errors = []
  end

  def valid?
    sender = NotificationSenderFactory.create(notification_params[:channel], user)
    dummy_notification = Notification.new(
      user: user,
      notification_type: notification_params[:notification_type],
      content: notification_params[:content],
      channel: notification_params[:channel]
    )
    
    result = sender.can_send?(dummy_notification)
    @errors << "Cannot send notification through #{notification_params[:channel]} channel" unless result
    result
  end

  def send_notification
    notification = create_notification
    sender = NotificationSenderFactory.create(notification_params[:channel], user)
    
    result = sender.send_notification(notification)
    update_notification_status(notification, result)
    result
  rescue => e
    handle_error(notification, e)
    false
  end

  private

  def create_notification
    user.notifications.create!(
      notification_type: notification_params[:notification_type],
      content: notification_params[:content],
      channel: notification_params[:channel],
      status: :pending
    )
  end

  def update_notification_status(notification, success)
    notification.update(status: success ? :sent : :failed)
  end

  def handle_error(notification, error)
    notification&.update(status: :failed)
    Rails.logger.error("Failed to send notification: #{error.message}")
  end
end
