class CreateCampaigns < ActiveRecord::Migration[4.2]
  def self.up
    create_table :campaigns do |t|
      t.string :cid, index: true
      t.string :slug, index: true
      t.string :title
      t.text :description
      t.string :image
      t.boolean :archived, default: false
      t.string :join_link, index: true
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :campaigns
  end
end
