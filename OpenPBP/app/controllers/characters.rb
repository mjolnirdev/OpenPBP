Openpbp::App.controllers :characters do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before except: [:index, :new] do
    @character = @campaign.characters.find_by_charid(params[:character_charid])
  end

  before :new do
    @character = @campaign.characters.new
  end

  before :delete do
    restrict_campaign_gm(@campaign, session[:user_id])
  end

  get :index, :map => "/:campaign_cid/:campaign_slug/characters", priority: :high do
    if campaign_gm?(@campaign, session[:user_id])
      @characters = @campaign.characters.where(retired: false).eager_load(:user)
      @retired_characters = @campaign.characters.where(retired: true).eager_load(:user)
    else
      @characters = @campaign.characters.where(user_id: session[:user_id]).where(retired: false).eager_load(:user)
      @characters = @campaign.characters.where(user_id: session[:user_id]).where(retired: true).eager_load(:user)
    end
    render 'characters/index'
  end

  get :new, :map => "/:campaign_cid/:campaign_slug/characters/new", priority: :high do
    render 'characters/new'
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/characters/new", priority: :high do
    @character.create_character(params, session[:user_id])
    if @character.save
      redirect "#{url_builder(@campaign)}/characters", success: 'character successfully created.'
    else
      flash.now[:error] = 'There was a problem creating this character.'
      render 'characters/new'
    end
  end

  get :edit, :map => "/:campaign_cid/:campaign_slug/characters/:character_charid/edit", priority: :high do
    render 'characters/edit'
  end

  post :edit, :map => "/:campaign_cid/:campaign_slug/characters/:character_charid/edit", priority: :high do
    @character.update_character(params)
    if @character.save
      redirect "#{url_builder(@campaign)}/characters/#{@character.charid}", success: 'character successfully edited.'
    else
      flash.now[:error] = 'There was a problem editing this character.'
      render 'characters/new'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/characters/:character_charid/delete", priority: :high do
    if @character.posts.count > 0 || @user.characters.where(campaign_id: @campaign.id).count == 1
      redirect "#{url_builder(@campaign)}/characters/#{@character.charid}", error: 'Last characters or characters with posts may not be deleted.'      
    else
      if @character.destroy
        redirect "#{url_builder(@campaign)}/characters", success: 'Character successfully deleted.'
      else
        redirect "#{url_builder(@campaign)}/characters", error: 'Character could not be deleted.'
      end
    end
  end

  get :primary, :map => "/:campaign_cid/:campaign_slug/characters/:character_charid/primary", priority: :high do
    if @character.retired == true
      redirect "#{url_builder(@campaign)}/characters", error: "Retired characters cannot be set primary"
    else
      @character.set_primary(@campaign, session[:user_id])
      redirect "#{url_builder(@campaign)}/characters", success: "#{@character.name} successfully made primary."
    end
  end

  get :retire, :map => "/:campaign_cid/:campaign_slug/characters/:character_charid/retire", priority: :high do
    if @character.default ==  false
      @character.retired = true
      if @character.save
        redirect "#{url_builder(@campaign)}/characters", success: "#{@character.name} successfully retired."
      else
        redirect "#{url_builder(@campaign)}/characters", error: "There was a problem retiring this character."
      end
    else
      redirect "#{url_builder(@campaign)}/characters", error: "Primary characters cannot be retired."
    end
  end
  
  get :show, :map => "/:campaign_cid/:campaign_slug/characters/:character_charid", priority: :high do
    render 'characters/show'
  end

end
