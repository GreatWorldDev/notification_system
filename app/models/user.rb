class User < ApplicationRecord
  has_many :devices, dependent: :destroy
  has_many :user_preferences, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, allow_blank: true, format: { with: /\A\+?[1-9]\d{1,14}\z/ }

  after_create :create_default_preferences

  private

  def create_default_preferences
    create_user_preferences unless user_preferences
  end
end
