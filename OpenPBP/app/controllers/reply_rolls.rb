Openpbp::App.controllers :reply_rolls do
  before do
    @campaign = Campaign.find_by_cid(params[:campaign_cid])
    @chapter = @campaign.chapters.find_by_slug(params[:chapter_slug])
    @scene = @chapter.scenes.find_by_slug(params[:scene_slug])
    @post = @scene.posts.find_by_pid(params[:post_pid])
    @reply = @post.replies.find_by_rid(params[:reply_rid])
    restrict_logged_in()
    restrict_campaign_member(@campaign, session[:user_id])
  end

  post :new, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/:reply_rid/dice/add" do
    dice = @reply.reply_rolls.new
    if dice.new_roll(params, session[:user_id])
      if dice.save
        redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:reply_rid]}", success: "Dice added successfully."
      else
        redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:reply_rid]}", error: "There was a problem adding these dice."
      end
    else
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:reply_rid]}", error: 'Dice could not be parsed, check your syntax.'
    end
  end

  get :delete, :map => "/:campaign_cid/:campaign_slug/:chapter_slug/:scene_slug/:post_pid/:reply_rid/dice/delete/:dice_id" do
    restrict_campaign_gm(@campaign, session[:user_id])
    @reply_roll = @reply.reply_rolls.find_by_id(params[:dice_id])
    if @reply_roll.destroy
      redirect "#{url_builder(@campaign, @chapter, @scene)}\##{params[:post_pid]}"
    end
  end

end
