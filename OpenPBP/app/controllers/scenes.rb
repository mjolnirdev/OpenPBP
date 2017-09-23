Openpbp::App.controllers :scenes do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before except: :new do
    @scene = @chapter.scenes.find_by_slug(params[:scene_slug])
  end

  before :new do
    @scene = @chapter.scenes.new
  end

  before except: :show do
    restrict_campaign_gm(@campaign, session[:user_id])
  end

  get :show, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug", priority: :low do
    @posts = @scene.posts.order(:created_at).eager_load(:post_rolls, :character, :replies, :user)
    last_visit(@scene, @campaign)
    render 'scenes/show'
  end

  get :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/scenes/new" do
    render 'scenes/new'
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/scenes/new" do
    @scene.update_scene(params)
    if @scene.save
      redirect "#{url_builder(@campaign, @chapter, @scene)}", success: "Successfully created scene."
    else
      flash.now[:error] = 'There was a problem with your submission.'
      render 'scenes/new'
    end
  end

  get :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/edit" do
    render 'scenes/edit'
  end

  post :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/edit" do
    @scene.update_scene(params)
    if @scene.save
      redirect "#{url_builder(@campaign, @chapter, @scene)}", success: 'Scene successfully updated.'
    else
      flash.now[:error] = 'There was a problem with your submission.'
      render 'scenes/edit'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/delete" do
    if @campaign.chapters.last.scenes.count == 1
      redirect "#{url_builder(@campaign, @chapter, @scene)}", error: 'Last scene cannot be deleted.'
    else
      if @scene.destroy
        redirect "#{url_builder(@campaign, @chapter)}", success: 'Scene deleted successfully.'
      else
        redirect "#{url_builder(@campaign, @chapter, @scene)}", error: 'There was an error deleting this scene.'
      end
    end
  end

end
