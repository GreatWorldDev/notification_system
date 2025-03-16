class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :notification_type, default: 0
      t.text :content, null: false
      t.integer :channel, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :notifications, :notification_type
    add_index :notifications, :channel
    add_index :notifications, :status
  end
end
