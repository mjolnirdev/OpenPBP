class CreateCharacters < ActiveRecord::Migration[4.2]
  def self.up
    create_table :characters do |t|
      t.integer :campaign_id, index: true
      t.integer :user_id, index: true
      t.string :charid, index: true
      t.string :name
      t.string :portrait
      t.text :bio
      t.boolean :gm, default: false
      t.boolean :default, default: false
      t.boolean :retired, default: false
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :characters
  end
end
