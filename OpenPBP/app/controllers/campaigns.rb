Openpbp::App.controllers :campaigns do

  before do
    restrict_logged_in
  end

  before except: [:index, :new] do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
  end

  before :edit, :delete, :join_link, :refresh_join_link do
    restrict_campaign_member(@campaign, session[:user_id])
    restrict_campaign_gm(@campaign, session[:user_id])
  end

  get :index, :map => '/campaigns' do
    @campaigns = User.find_by_id(session[:user_id]).campaigns
    render 'campaigns/index'
  end

  get :show, :map => '/:campaign_cid/:campaign_slug/', priority: :low do
    restrict_campaign_member(@campaign, session[:user_id])
    @members = @campaign.campaign_memberships
    @chapters = @campaign.chapters
    if @campaign.nil?
      redirect '/campaigns', error: 'Campaign not found.'
    else
      render 'campaigns/show'
    end
  end

  get :new, :map => '/campaign/new' do
    @campaign = Campaign.new
    render 'campaigns/new'
  end

  post :new, :map => '/campaign/new' do
    @campaign = Campaign.new
    @campaign.create_campaign(params)
    @membership = @campaign.campaign_memberships.new
    @membership.create_campaign_membership(session[:user_id])
    if @campaign.save && @membership.save
      @campaign.seed_campaign(session[:user_id])
      redirect url_builder(@campaign), success: 'Campaign created successfully.'
    else
      flash.now[:error] = 'There was a problem with your submission'
      render 'campaigns/new'
    end
  end

  get :edit, :map => '/:campaign_cid/:campaign_slug/edit' do
    if @campaign.nil?
      redirect '/campaigns', error: 'Campaign not found.'
    else
      render 'campaigns/edit'
    end
  end

  post :edit, :map => '/:campaign_cid/:campaign_slug/edit' do
    @campaign.update_campaign(params)
    if @campaign.save
      redirect url_builder(@campaign), success: 'Campaign updated successfully.'
    else
      flash.now[:error] = 'There was a problem with your submission'
      render 'campaigns/edit'
    end
  end

  get :delete, :map => '/:campaign_cid/:campaign_slug/delete' do
    restrict_campaign_owner(@campaign, session[:user_id])
    if @campaign.destroy
      redirect '/campaigns', success: 'Campaign deleted successfully.'
    else
      redirect url_builder(@campaign), error: 'There was an error deleting this campaign.'
    end
  end

  get :join_link, :map => '/:campaign_cid/:campaign_slug/join_link' do
    @join_link = @campaign.join_link
    render 'campaigns/join_link'
  end

  get :refresh_join_link, :map => '/:campaign_cid/:campaign_slug/join_link/refresh' do
    @campaign.refresh_join_link
    if @campaign.save
      redirect "#{url_builder(@campaign)}/join_link/", success: 'Campaign link successfully refreshed.'
    else
      flash.now[:error] = 'There was a problem refreshing the join link.'
      render 'campaigns/join_link'
    end
  end

end
