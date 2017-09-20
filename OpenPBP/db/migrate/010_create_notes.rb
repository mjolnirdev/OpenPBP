class CreateNotes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :notes do |t|
      t.string :nid, index: true
      t.integer :post_id, index: true
      t.integer :campaign_id, index: true
      t.integer :user_id, index: true
      t.string :slug, index: true
      t.string :title
      t.text :note
      t.boolean :public_note
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :notes
  end
end
