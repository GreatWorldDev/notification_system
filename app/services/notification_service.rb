class NotificationService
  attr_reader :user, :notification_params, :errors

  def initialize(user, notification_params)
    @user = user
    @notification_params = notification_params
    @errors = []
    @preferences = user.user_preference
  end

  def valid?
    validate_channel_enabled
    validate_user_info

    @errors.empty?
  end

  def send_notification
    notification = user.notifications.create(
      notification_type: notification_params[:notification_type],
      content: notification_params[:content],
      channel: notification_params[:channel],
      status: :pending
    )

    sender = notification_sender(notification_params[:channel])

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

  def validate_channel_enabled
    case notification_params[:channel].to_sym
    when :email
      @errors << "Email notifications disabled for this user" unless @preferences.email_notifications
    when :sms
      @errors << "SMS notifications disabled for this user" unless @preferences.sms_notifications
    when :push
      @errors << "Push notifications disabled for this user" unless @preferences.push_notifications
    end
  end

  def validate_user_info
    case notification_params[:channel].to_sym
    when :email
      @errors << "User has no email address" if user.email.blank?
    when :sms
      @errors << "User has no phone number" if user.phone_number.blank?
    when :push
      @errors << "User has no devices" if user.devices.empty?
    end
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
