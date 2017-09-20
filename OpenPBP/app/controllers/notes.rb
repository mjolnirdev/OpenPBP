Openpbp::App.controllers :notes do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    restrict_logged_in
    restrict_campaign_member(@campaign, session[:user_id])
  end

  before except: [:index, :sidebar, :new] do
    @note = Note.find_by_nid(params[:note_nid])
    @post = @note.post
    @scene = @post.scene
    @chapter = @scene.chapter
  end

  before :new do
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
    @scene = @chapter.scenes.find_by_slug(params[:scene_slug])
    @post = @scene.posts.find_by_pid(params[:post_pid])
    @note = @post.notes.new
  end

  before :edit, :delete do
    restrict_content_owner(@note, @campaign, session[:user_id])
  end

  get :index, :map => "/:campaign_cid/:campaign_slug/notes/", priority: :high do
    @notes = User.find_by_id(session[:user_id]).notes.where(campaign_id: @campaign.id)
    render 'notes/index'
  end

  get :sidebar, :map => "/:campaign_cid/:campaign_slug/notes/sidebar", priority: :high do
    @notes = User.find_by_id(session[:user_id]).notes.where(campaign_id: @campaign.id)
    render 'notes/sidebar_content', layout: false
  end

  get :show, :map => "/:campaign_cid/:campaign_slug/notes/:note_nid/:note_slug", priority: :high do
    unless @note.public_note == true
      restrict_content_owner(@note, @campaign, session[:user_id])
    end
    render 'notes/show'
  end

  get :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/note/new", priority: :high do
    render 'notes/new'
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/note/new", priority: :high do
    @note.new_note(params, @campaign, session[:user_id])
    if @note.save
      redirect "#{url_builder(@campaign)}/notes/#{@note.nid}/#{@note.slug}", success: 'Note added successfully.'
    else
      flash.now[:error] = 'There was a problem adding this note.'
      render 'notes/new'
    end
  end

  get :edit, :map => "/:campaign_cid/:campaign_slug/notes/:note_nid/:note_slug/edit", priority: :high do
    render 'notes/edit'
  end

  post :edit, :map => "/:campaign_cid/:campaign_slug/notes/:note_nid/:note_slug/edit", priority: :high do
    @note.update_note(params)
    if @note.save
      redirect "#{url_builder(@campaign)}/notes/#{@note.nid}/#{@note.slug}", success: 'Note edited successfully.'
    else
      flash.now[:error] = 'There was a problem editing your note.'
      render 'notes/edit'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/notes/:note_nid/:note_slug/delete", priority: :high do
    if @note.destroy
      redirect "#{url_builder(@campaign, @chapter, @scene)}", success: 'Note successfully deleted.'
    else
      redirect "#{url_builder(@campaign)}/notes/#{@note.nid}/#{@note.slug}", error: 'There was a problem deleting this note.'
    end
  end

end
