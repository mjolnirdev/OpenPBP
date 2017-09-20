class CreateChapters < ActiveRecord::Migration[4.2]
  def self.up
    create_table :chapters do |t|
      t.integer :campaign_id, index: true
      t.string :slug, index: true
      t.string :title
      t.text :description
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :chapters
  end
end
