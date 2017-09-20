# Method access restrictions
def restrict_logged_in
  if session[:user_id]
    @user = User.find_by_id(session[:user_id])
  else
    session[:redirect] = @request.env["PATH_INFO"]
    redirect '/login', error: 'You must be logged in to view this page.'
  end
end

def restrict_campaign_member(campaign, user_id)
  unless campaign && campaign.campaign_memberships.find_by_user_id(user_id)
    redirect '/campaigns', error: 'You are not a member of this campaign.'
  end
end

def restrict_campaign_gm(campaign, user_id)
  unless campaign && campaign.campaign_memberships.find_by_user_id(user_id).gm
    redirect '/campaigns', error: 'You do not have permission to modify this campaign.'
  end
end

def restrict_campaign_owner(campaign, user_id)
  unless campaign && campaign.campaign_memberships.find_by_user_id(user_id).owner
    redirect '/campaigns', error: 'You do not have permission to modify this campaign'
  end
end

def restrict_content_owner(content, campaign, user_id)
  unless content_owner?(content, user_id) || campaign_gm?(campaign, user_id)
    redirect '/campaigns', error: 'You do not have permission to do that.'
  end
end