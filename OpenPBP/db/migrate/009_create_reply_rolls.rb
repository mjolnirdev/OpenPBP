class CreateReplyRolls < ActiveRecord::Migration[4.2]
  def self.up
    create_table :reply_rolls do |t|
      t.integer :reply_id, index: true
      t.integer :user_id, index: true
      t.text :rolled_dice
      t.text :results
      t.string :modifier
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :reply_rolls
  end
end
