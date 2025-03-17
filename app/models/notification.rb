class Notification < ApplicationRecord
  belongs_to :user

  enum :notification_type, {
    alert: 0,
    reminder: 1,
    promotional: 2,
    system: 3
  }

  enum :channel, {
    email: 0,
    sms: 1,
    push: 2
  }

  enum :status, {
    pending: 0,
    sent: 1,
    failed: 2
  }

  validates :content, presence: true
  validates :notification_type, presence: true
  validates :channel, presence: true
  validates :status, presence: true
end
