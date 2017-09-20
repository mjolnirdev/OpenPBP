Openpbp::App.controllers :chapters do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before except: :new do
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
  end

  before :new do
    @chapter = @campaign.chapters.new
  end

  before except: :show do
    restrict_campaign_gm(@campaign, session[:user_id])
  end

  get :show, :map => "/:campaign_cid/:campaign_slug/:chapter_slug", priority: :low do
    @scenes = @chapter.scenes
    render 'chapters/show'
  end

  get :new, :map => "/:campaign_cid/:campaign_slug/chapters/new" do
    render 'chapters/new'
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/chapters/new" do
    @chapter.update_chapter(params)
    if @chapter.save
      redirect "#{url_builder(@campaign, @chapter)}", success: "Successfully created chapter."
    else
      flash.now[:error] = 'There was a problem with your submission.'
      render 'chapters/new'
    end
  end

  get :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/edit" do
    render 'chapters/edit'
  end

  post :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/edit" do
    @chapter.update_chapter(params)
    if @chapter.save
      redirect "#{url_builder(@campaign, @chapter)}", success: 'Chapter successfully updated.'
    else
      flash.now[:error] = 'There was a problem with your submission.'
      render 'chapters/edit'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/delete" do
    if @campaign.chapters.count == 1
      redirect "#{url_builder(@campaign, @chapter)}", error: 'Last chapter cannot be deleted.'
    else
      if @chapter.destroy
        redirect "#{url_builder(@campaign)}", success: 'Chapter deleted successfully.'
      else
        redirect "#{url_builder(@campaign, @chapter)}", error: 'There was an error deleting this chapter.'
      end
    end
  end
end
