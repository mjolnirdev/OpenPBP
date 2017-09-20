class CreateCampaignMemberships < ActiveRecord::Migration[4.2]
  def self.up
    create_table :campaign_memberships do |t|
      t.integer :user_id, index: true
      t.integer :campaign_id, index: true
      t.boolean :gm, default: false
      t.boolean :owner, default: false
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :campaign_memberships
  end
end
