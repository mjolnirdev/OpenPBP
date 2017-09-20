Openpbp::App.controllers :post_rolls do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
    @scene = @chapter.scenes.find_by_slug(params[:scene_slug])
    @post = @scene.posts.find_by_pid(params[:post_pid])
    restrict_logged_in()
    restrict_campaign_member(@campaign, session[:user_id])
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/dice/add" do
    dice = @post.post_rolls.new
    if dice.new_roll(params, session[:user_id])
      if dice.save
        redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:post_pid]}", success: "Dice added successfully."
      else
        redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:post_pid]}", error: "There was a problem adding these dice."
      end
    else
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:post_pid]}", error: 'Dice could not be parsed, check your syntax.'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/dice/delete/:dice_id" do
    restrict_campaign_gm(@campaign, session[:user_id])
    @post_roll = @post.post_rolls.find_by_id(params[:dice_id])
    if @post_roll.destroy
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:post_pid]}"
    end
  end

end
