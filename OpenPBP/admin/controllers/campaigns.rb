Openpbp::Admin.controllers :campaigns do
  get :index do
    @title = "Campaigns"
    @campaigns = Campaign.all
    render 'campaigns/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'campaign')
    @campaign = Campaign.new
    render 'campaigns/new'
  end

  post :create do
    @campaign = Campaign.new(params[:campaign])
    if @campaign.save
      @title = pat(:create_title, :model => "campaign #{@campaign.id}")
      flash[:success] = pat(:create_success, :model => 'Campaign')
      params[:save_and_continue] ? redirect(url(:campaigns, :index)) : redirect(url(:campaigns, :edit, :id => @campaign.id))
    else
      @title = pat(:create_title, :model => 'campaign')
      flash.now[:error] = pat(:create_error, :model => 'campaign')
      render 'campaigns/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "campaign #{params[:id]}")
    @campaign = Campaign.find(params[:id])
    if @campaign
      render 'campaigns/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'campaign', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "campaign #{params[:id]}")
    @campaign = Campaign.find(params[:id])
    if @campaign
      if @campaign.update_attributes(params[:campaign])
        flash[:success] = pat(:update_success, :model => 'Campaign', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:campaigns, :index)) :
          redirect(url(:campaigns, :edit, :id => @campaign.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'campaign')
        render 'campaigns/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'campaign', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Campaigns"
    campaign = Campaign.find(params[:id])
    if campaign
      if campaign.destroy
        flash[:success] = pat(:delete_success, :model => 'Campaign', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'campaign')
      end
      redirect url(:campaigns, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'campaign', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Campaigns"
    unless params[:campaign_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'campaign')
      redirect(url(:campaigns, :index))
    end
    ids = params[:campaign_ids].split(',').map(&:strip)
    campaigns = Campaign.find(ids)
    
    if Campaign.destroy campaigns
    
      flash[:success] = pat(:destroy_many_success, :model => 'Campaigns', :ids => "#{ids.join(', ')}")
    end
    redirect url(:campaigns, :index)
  end
end
