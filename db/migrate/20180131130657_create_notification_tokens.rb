class CreateNotificationTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_tokens do |t|
      t.string :uuid, null: false
      t.string :token, null: false

      t.timestamps null: false
    end
    add_index :notification_tokens, :uuid, unique: true
    add_index :notification_tokens, :token, unique: true
    add_index :notification_tokens, :created_at
  end
end
