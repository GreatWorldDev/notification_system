class EmailNotificationSender < NotificationSender
  protected

  def can_send?(notification)
    user.user_preference.email_notifications && user.email.present?
  end

  def do_send_notification(notification)
    NotificationMailer.send_notification(
      user.email,
      notification.content,
      notification.notification_type
    ).deliver_now
    true
  rescue => e
    Rails.logger.error("Failed to send email notification: #{e.message}")
    false
  end
end
