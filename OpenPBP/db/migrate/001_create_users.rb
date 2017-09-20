class CreateUsers < ActiveRecord::Migration[4.2]
  def self.up
    create_table :users do |t|
      t.string :uid, index: true
      t.string :email
      t.string :display_name
      t.string :password_hash
      t.boolean :email_confirmed
      t.boolean :password_reset
      t.string :password_link
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :users
  end
end
