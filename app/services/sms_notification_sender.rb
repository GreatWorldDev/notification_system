class SmsNotificationSender < NotificationSender
  def send_notification(notification)
    # check if user has enabled SMS notifications
    # and if user has a valid phone number
    return false unless valid?

    # use Twilio to send SMS
    client = Twilio::REST::Client.new(
      ENV["TWILIO_ACCOUNT_SID"],
      ENV["TWILIO_AUTH_TOKEN"]
    )

    client.messages.create(
      from: ENV["TWILIO_PHONE_NUMBER"],
      to: user.phone_number,
      body: notification.content
    )

    true
  rescue => e
    Rails.logger.error("Failed to send SMS notification to #{user.phone_number}: #{e.message}")
    false
  end

  def valid?
    validate_channel_enabled
    validate_user_info
    true
  end

  private

  def validate_channel_enabled
    raise "SMS notifications disabled for this user" unless @preferences.sms_notifications
  end

  def validate_user_info
    raise "User has no phone number" if user.phone_number.blank?
  end
end
