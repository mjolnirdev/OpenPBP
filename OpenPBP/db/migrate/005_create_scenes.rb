class CreateScenes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :scenes do |t|
      t.integer :chapter_id, index: true
      t.string :slug, index: true
      t.string :title
      t.text :description
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :scenes
  end
end
