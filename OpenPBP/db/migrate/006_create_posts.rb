class CreatePosts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :posts do |t|
      t.string :pid, index: true
      t.integer :scene_id, index: true
      t.integer :user_id, index: true
      t.integer :character_id, index: true
      t.text :post
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :posts
  end
end
