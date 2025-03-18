class NotificationMailer < ApplicationMailer
  default from: ENV["MAILER_SENDER"] || "no-reply@email.com"

  def send_notification(recipient_email, content, notification_type)
    @content = content
    @notification_type = notification_type

    mail(to: recipient_email, subject: NotificationHelper.notification_title(notification_type))
  end
end
