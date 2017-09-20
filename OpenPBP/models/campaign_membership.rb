class CampaignMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  def create_campaign_membership(user_id)
    self.user_id = user_id
    self.gm = true
    self.owner = true
  end

  def join_campaign(user_id)
    self.user_id = user_id
    self.gm = false
    self.owner = false
  end
end
