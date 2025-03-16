class CreateGroupUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :group_users, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :group_users, [ :group_id, :user_id ], unique: true
  end
end
