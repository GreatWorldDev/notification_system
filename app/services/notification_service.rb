class NotificationService
  attr_reader :user, :notification_params, :errors

  def initialize(user, notification_params)
    @user = user
    @notification_params = notification_params
    @errors = []
  end

  def valid?
    begin
      sender.valid?
      true
    rescue => e
      @errors << e.message
      false
    end
  end

  def send_notification
    notification = user.notifications.create(
      notification_type: notification_params[:notification_type],
      content: notification_params[:content],
      channel: notification_params[:channel],
      status: :pending
    )

    begin
      # send the notification through the selected channel
      result = sender.send_notification(notification)

      if result
        notification.update(status: :sent)
        true
      else
        notification.update(status: :failed)
        false
      end
    rescue => e
      notification.update(status: :failed)
      Rails.logger.error("Failed to send notification: #{e.message}")
      false
    end
  end

  private

  def sender
    @sender ||= notification_sender(notification_params[:channel])
  end

  def notification_sender(channel)
    case channel.to_sym
    when :email
      EmailNotificationSender.new(user)
    when :sms
      SmsNotificationSender.new(user)
    when :push
      PushNotificationSender.new(user)
    else
      raise ArgumentError, "Invalid channel"
    end
  end
end
