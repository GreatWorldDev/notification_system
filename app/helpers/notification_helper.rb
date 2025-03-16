module NotificationHelper
  def self.notification_title(notification_type)
    case notification_type.to_sym
    when :alert
      "Important Alert"
    when :reminder
      "Reminder"
    when :promotional
      "Special Offer"
    when :system
      "System Notification"
    else
      "Notification"
    end
  end
end
