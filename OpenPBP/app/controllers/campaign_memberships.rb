Openpbp::App.controllers :campaign_memberships do
  before do
    restrict_logged_in
  end

  before :leave, :edit, :index, :delete do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before :delete do
    restrict_campaign_gm(@campaign, session[:user_id])
  end

  get :index, :map => '/:campaign_cid/:campaign_slug/members', priority: :high do
    @campaign_members = @campaign.campaign_memberships.eager_load(:user).all
    render 'campaign_memberships/index'
  end

  get :delete, :map => '/:campaign_cid/:campaign_slug/members/delete/:membership_id', priority: :high do
    @member = @campaign.campaign_memberships.find_by_id(params[:membership_id])
    @user = @member.user
    if @member.owner
      redirect "#{url_builder(@campaign)}/members", error: 'You cannot remove owners from campaigns, consider deleting it instead.'
    elsif @member.destroy
      @campaign.refresh_join_link
      @campaign.save
      @user.drop_primary(@campaign)
      redirect "#{url_builder(@campaign)}/members", success: 'Member successfully removed. Campaign Join Link has been regenerated.'
    end
  end

  get :join, :map => '/join/:join_link', priority: :high do
    @campaign = Campaign.find_by_join_link(params[:join_link])
    if campaign_member?(@campaign, session[:user_id]).nil?
      @campaign_membership = @campaign.campaign_memberships.new
      @campaign_membership.join_campaign(session[:user_id])
      if @campaign_membership.save
        charid = @campaign.seed_character(session[:user_id])
        redirect "#{url_builder(@campaign)}/characters/#{charid}/edit", success: "You have successfully joined #{@campaign.title}!"
      else
        redirect "/campaigns", error: "There was an issue joining this campaign."
      end
    else
      redirect url_builder(@campaign), error: "You are already a member of this campaign."
    end
  end

  get :leave, :map => '/:campaign_cid/:campaign_slug/leave', priority: :high do
    if campaign_owner?(@campaign, session[:user_id])
      redirect url_builder(@campaign), error: "Owners can't leave their campaigns, transfer ownership to a player or delete the campaign."
    else
      @campaign.campaign_memberships.where(user_id: session[:user_id]).delete_all
      redirect '/campaigns', success: "You have successfully left #{@campaign.title}."
    end
  end
end
