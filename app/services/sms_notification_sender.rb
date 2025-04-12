class SmsNotificationSender < NotificationSender
  protected

  def can_send?(notification)
    user.user_preference.sms_notifications && user.phone_number.present?
  end

  def do_send_notification(notification)
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
    Rails.logger.error("Failed to send SMS notification: #{e.message}")
    false
  end
end
