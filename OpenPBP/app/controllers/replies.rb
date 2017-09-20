Openpbp::App.controllers :replies do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
    @scene = @chapter.scenes.find_by_slug(params[:scene_slug])
    @post = @scene.posts.find_by_pid(params[:post_pid])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before except: :new do
    @reply = @post.replies.find_by_rid(params[:reply_rid])
  end

  before :new do
    @reply = @post.replies.new
  end

  before :edit, :delete do
    restrict_content_owner(@reply, @campaign, session[:user_id])
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/reply/new" do
    @reply.new_reply(params, session[:user_id])
    if @reply.save
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", success: "Successfully created reply."
    else
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", error: "There was a problem with your reply."
    end
  end

  get :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/:reply_rid/edit" do
    render 'replies/edit'
  end

  post :edit, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/:reply_rid/edit" do
    @reply.update_reply(params)
    if @reply.save
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", success: 'Reply edited successfully.'
    else
      flash.now[:error] = 'There was an error editing your reply.'
      render 'replies/edit'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/:reply_rid/delete" do
    if @reply.destroy
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", success: 'Reply deleted successfully.'
    else
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{@post.pid}", error: 'There was a problem deleting his reply.'
    end
  end

end
