class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :device_token, null: false

      t.timestamps
    end
    add_index :devices, :device_token, unique: true
  end
end
