class PushNotificationSender < NotificationSender
  def send_notification(notification)
    # check if user has enabled push notifications
    # and if user has devices registered
    return false unless valid?

    # get device tokens from user's devices
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

    # Send to all devices
    response = fcm.send(device_tokens, payload)

    success = JSON.parse(response[:body])["success"]

    success
  rescue => e
    Rails.logger.error("Failed to send push notification: #{e.message}")
    false
  end

  def valid?
    validate_channel_enabled
    validate_user_info
    true
  end

  private

  def validate_channel_enabled
    raise "Push notifications disabled for this user" unless @preferences.push_notifications
  end

  def validate_user_info
    raise "User does not have devices" if user.devices.empty?
  end
end
