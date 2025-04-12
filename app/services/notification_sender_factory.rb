class NotificationSenderFactory
  @senders = {}

  class << self
    def register(channel, sender_class)
      @senders[channel.to_sym] = sender_class
    end

    def create(channel, user)
      sender_class = @senders[channel.to_sym]
      raise ArgumentError, "Invalid channel" unless sender_class
      sender_class.new(user)
    end
  end
end 