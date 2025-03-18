class EmailNotificationSender < NotificationSender
  def send_notification(notification)
    return false unless user.user_preference.email_notifications

    # Send an email to the user
    NotificationMailer.send_notification(
      user.email,
      notification.content,
      notification.notification_type
    ).deliver_now

    true
  rescue => e
    Rails.logger.error("Failed to send email notification to #{user.email}: #{e.message}")
    false
  end
end
