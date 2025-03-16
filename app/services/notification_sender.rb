class NotificationSender
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def send_notification(notification)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end
end
