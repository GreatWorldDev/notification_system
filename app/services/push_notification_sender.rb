class PushNotificationSender < NotificationSender
  protected

  def can_send?(notification)
    user.user_preference.push_notifications && user.devices.any?
  end

  def do_send_notification(notification)
    device_tokens = user.devices.pluck(:device_token)
    fcm = FCM.new(ENV["FCM_SERVER_KEY"])

    payload = {
      notification: {
        title: NotificationHelper.notification_title(
          notification.notification_type
        ),
        body: notification.content
      },
      data: {
        notification_id: notification.id,
        notification_type: notification.notification_type
      }
    }

    response = fcm.send(device_tokens, payload)
    success = JSON.parse(response[:body])["success"]
    success
  rescue => e
    Rails.logger.error("Failed to send push notification: #{e.message}")
    false
  end
end
