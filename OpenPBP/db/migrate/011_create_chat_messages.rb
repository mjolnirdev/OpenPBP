class CreateChatMessages < ActiveRecord::Migration[4.2]
  def self.up
    create_table :chat_messages do |t|
      t.integer :campaign_id, index: true
      t.integer :user_id, index: true
      t.string :name
      t.text :message
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :chat_messages
  end
end
