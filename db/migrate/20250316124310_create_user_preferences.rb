class CreateUserPreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :user_preferences, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.boolean :email_notifications, default: true
      t.boolean :sms_notifications, default: false
      t.boolean :push_notifications, default: false

      t.timestamps
    end
  end
end
