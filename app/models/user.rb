class User < ApplicationRecord
  has_many :devices, dependent: :destroy
  has_one :user_preference, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, allow_blank: true, format: { with: /\A\+?[1-9]\d{1,14}\z/ }

  after_commit :create_default_preferences, on: :create

  private

  def create_default_preferences
    create_user_preference unless user_preference
  end
end
