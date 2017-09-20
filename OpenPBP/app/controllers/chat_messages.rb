Openpbp::App.controllers :chat_messages do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before :new do
    @chat_message = @campaign.chat_messages.new
  end

  before :delete do
    restrict_campaign_gm(@campaign, session[:user_id])
  end

  get :index, :map => "/:campaign_cid/:campaign_slug/ooc"  do
    @old_chat_messages = @campaign.chat_messages.where(:created_at => @campaign.created_at..1.day.ago).limit(50)
    @today_chat_messages = @campaign.chat_messages.where(:created_at => 1.day.ago..1.hour.ago)
    @recent_chat_messages = @campaign.chat_messages.where(:created_at => 1.hour.ago..10.minutes.ago)
    @current_chat_messages = @campaign.chat_messages.where(:created_at => 10.minutes.ago..Time.now)
    render 'chat_messages/index', layout: false
  end
  get :count, :map => "/:campaign_cid/:campaign_slug/ooc/count"  do
    @chat_messages_total = @campaign.chat_messages.count
    render 'chat_messages/count', layout: false
  end

  get :archive, :map => "/:campaign_cid/:campaign_slug/ooc/history"  do
    @chat_messages = @campaign.chat_messages.all
    render 'chat_messages/history', layout: false
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/ooc/new" do
    names = safe_names(@campaign, session[:user_id])
    if names.include?(params[:name])
      @chat_message.new_chat_message(params, session[:user_id])
      @chat_message.save
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/ooc/delete/:chat_messsage_id" do
    if @campaign.chat_messages.find_by_id(params[:chat_messsage_id]).destroy
      redirect "#{url_builder(@campaign)}/ooc/history", success: 'Chat message successfully deleted.'
    else
      redirect "#{url_builder(@campaign)}/ooc/history", failure: 'Chat message could not be deleted.'
    end
  end

end
