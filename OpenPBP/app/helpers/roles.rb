# Role checkers
def logged_in?
  session[:user_id] != nil
end

def campaign_member?(campaign, user_id)
  campaign.campaign_memberships.find_by_user_id(user_id)
end

def campaign_gm?(campaign, user_id)
  campaign.campaign_memberships.find_by_user_id(user_id).gm
end

def campaign_owner?(campaign, user_id)
  campaign.campaign_memberships.find_by_user_id(user_id).owner
end

def content_owner?(content, user_id)
  content.user_id == user_id
end