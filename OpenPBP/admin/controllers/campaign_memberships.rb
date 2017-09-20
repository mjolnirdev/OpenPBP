Openpbp::Admin.controllers :campaign_memberships do
  get :index do
    @title = "Campaign_memberships"
    @campaign_memberships = CampaignMembership.all
    render 'campaign_memberships/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'campaign_membership')
    @campaign_membership = CampaignMembership.new
    render 'campaign_memberships/new'
  end

  post :create do
    @campaign_membership = CampaignMembership.new(params[:campaign_membership])
    if @campaign_membership.save
      @title = pat(:create_title, :model => "campaign_membership #{@campaign_membership.id}")
      flash[:success] = pat(:create_success, :model => 'CampaignMembership')
      params[:save_and_continue] ? redirect(url(:campaign_memberships, :index)) : redirect(url(:campaign_memberships, :edit, :id => @campaign_membership.id))
    else
      @title = pat(:create_title, :model => 'campaign_membership')
      flash.now[:error] = pat(:create_error, :model => 'campaign_membership')
      render 'campaign_memberships/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "campaign_membership #{params[:id]}")
    @campaign_membership = CampaignMembership.find(params[:id])
    if @campaign_membership
      render 'campaign_memberships/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'campaign_membership', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "campaign_membership #{params[:id]}")
    @campaign_membership = CampaignMembership.find(params[:id])
    if @campaign_membership
      if @campaign_membership.update_attributes(params[:campaign_membership])
        flash[:success] = pat(:update_success, :model => 'Campaign_membership', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:campaign_memberships, :index)) :
          redirect(url(:campaign_memberships, :edit, :id => @campaign_membership.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'campaign_membership')
        render 'campaign_memberships/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'campaign_membership', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Campaign_memberships"
    campaign_membership = CampaignMembership.find(params[:id])
    if campaign_membership
      if campaign_membership.destroy
        flash[:success] = pat(:delete_success, :model => 'Campaign_membership', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'campaign_membership')
      end
      redirect url(:campaign_memberships, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'campaign_membership', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Campaign_memberships"
    unless params[:campaign_membership_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'campaign_membership')
      redirect(url(:campaign_memberships, :index))
    end
    ids = params[:campaign_membership_ids].split(',').map(&:strip)
    campaign_memberships = CampaignMembership.find(ids)
    
    if CampaignMembership.destroy campaign_memberships
    
      flash[:success] = pat(:destroy_many_success, :model => 'Campaign_memberships', :ids => "#{ids.join(', ')}")
    end
    redirect url(:campaign_memberships, :index)
  end
end
