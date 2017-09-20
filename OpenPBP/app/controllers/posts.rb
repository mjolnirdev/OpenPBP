Openpbp::App.controllers :posts do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
    @scene = @chapter.scenes.find_by_slug(params[:scene_slug])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before except: :new do
    @post = @scene.posts.find_by_pid(params[:post_pid])
  end

  before :new do
    @post = @scene.posts.new
  end

  before :edit, :delete do
    restrict_content_owner(@post, @campaign, session[:user_id])
  end

  get :show, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid", priority: :low do
    render 'posts/show'
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/posts/new" do
    @post.new_post(params, session[:user_id])
    if @post.save
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", success: "Successfully created post."
    else
      redirect "#{url_builder(@campaign, @chapter, @scene)}", error: "There was a problem with your post."
    end
  end

  get :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/edit" do
    render 'posts/edit'

  end

  post :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/edit" do
    @post.update_post(params)
    if @post.save
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", success: "Successfully edited post."
    else
      flash.now[:error] = 'There was an error editing this post.'
      render "posts/edit"
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/delete" do
    if @post.destroy
      redirect "#{url_builder(@campaign, @chapter, @scene)}", success: 'Post successfully deleted.'
    else
      redirect "#{url_builder(@campaign, @chapter, @scene)}", error: 'There was an error deleting this post.'
    end
  end
end
