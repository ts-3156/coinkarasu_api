class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :uuid, null: false
      t.string :key, null: false
      t.string :secret, null: false

      t.timestamps null: false
    end
    add_index :apps, :uuid, unique: true
    add_index :apps, :key, unique: true
    add_index :apps, :secret, unique: true
    add_index :apps, :created_at
  end
end
