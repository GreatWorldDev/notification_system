class SendNotificationJob
  include Sidekiq::Job

  sidekiq_options retry: 3

  def perform(user_id, notification_params)
    user = User.find(user_id)
    return Rails.logger.warn("User #{user_id} not found, skipping notification") unless user

    notification_service = NotificationService.new(user, notification_params.symbolize_keys)

    unless notification_service.valid?
      Rails.logger.warn("Skipping notification for user #{user_id}: #{notification_service.errors.join(', ')}")
      return
    end

    result = notification_service.send_notification

    if result
      Rails.logger.info("Notification sent successfully to user #{user_id}")
    else
      Rails.logger.error("Failed to send notification to user #{user_id}")
    end
  end
end
