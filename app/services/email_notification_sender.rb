class EmailNotificationSender < NotificationSender
  def send_notification(notification)
    # Check if user has enabled email notifications
    # and if user has a valid email address
    return false unless valid?

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

  def valid?
    validate_channel_enabled
    validate_user_info
    true
  end

  private

  def validate_channel_enabled
    raise "Email notifications disabled for this user" unless @preferences.email_notifications
  end

  def validate_user_info
    raise "User does not have email address" if user.email.blank?
  end
end
