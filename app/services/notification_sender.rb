class NotificationSender
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def send_notification(notification)
    return false unless can_send?(notification)
    do_send_notification(notification)
  end

  protected

  def can_send?(notification)
    raise NotImplementedError
  end

  def do_send_notification(notification)
    raise NotImplementedError
  end
end
