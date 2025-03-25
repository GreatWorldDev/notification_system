class NotificationSender
  attr_reader :user

  def initialize(user)
    @user = user
    @preferences = user.user_preference
  end

  def valid?
    raise NotImplementedError, "Validation must be implemented in a subclass"
  end

  def send_notification(notification)
    raise NotImplementedError, "Send notification must be implemented in a subclass"
  end

  private

  def validate_channel_enabled
    raise NotImplementedError, "Channel validation must be implemented in a subclass"
  end

  def validate_user_info
    raise NotImplementedError, "User info validation must be implemented in a subclass"
  end
end
