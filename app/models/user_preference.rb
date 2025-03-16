class UserPreference < ApplicationRecord
  belongs_to :user

  validates :email_notifications, inclusion: { in: [ true, false ] }
  validates :push_notifications, inclusion: { in: [ true, false ] }
  validates :sms_notifications, inclusion: { in: [ true, false ] }

  validate :at_least_one_channel_enabled

  private

  def at_least_one_channel_enabled
    unless email_notifications || sms_notifications || push_notifications
      errors.add(:base, "At least one notification channel must be enabled")
    end
  end
end
