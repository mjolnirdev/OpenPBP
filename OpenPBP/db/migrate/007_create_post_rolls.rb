class CreatePostRolls < ActiveRecord::Migration[4.2]
  def self.up
    create_table :post_rolls do |t|
      t.integer :user_id, index: true
      t.integer :post_id, index: true
      t.text :rolled_dice
      t.text :results
      t.string :modifier
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :post_rolls
  end
end
