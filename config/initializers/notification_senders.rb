NotificationSenderFactory.register(:email, EmailNotificationSender)
NotificationSenderFactory.register(:sms, SmsNotificationSender)
NotificationSenderFactory.register(:push, PushNotificationSender) 