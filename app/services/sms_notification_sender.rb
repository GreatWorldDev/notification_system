class SmsNotificationSender < NotificationSender
  def send_notification(notification)
    # send SMS
    return false unless user.user_preference.sms_notifications || user.phone_number.present

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
end
