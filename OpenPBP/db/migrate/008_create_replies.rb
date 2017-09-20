class CreateReplies < ActiveRecord::Migration[4.2]
  def self.up
    create_table :replies do |t|
      t.integer :post_id, index: true
      t.integer :user_id, index: true
      t.integer :character_id, index: true
      t.string :rid, index: true
      t.text :reply
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :replies
  end
end
