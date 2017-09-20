Openpbp::Admin.controllers :reply_rolls do
  get :index do
    @title = "Reply_rolls"
    @reply_rolls = ReplyRoll.all
    render 'reply_rolls/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'reply_roll')
    @reply_roll = ReplyRoll.new
    render 'reply_rolls/new'
  end

  post :create do
    @reply_roll = ReplyRoll.new(params[:reply_roll])
    if @reply_roll.save
      @title = pat(:create_title, :model => "reply_roll #{@reply_roll.id}")
      flash[:success] = pat(:create_success, :model => 'ReplyRoll')
      params[:save_and_continue] ? redirect(url(:reply_rolls, :index)) : redirect(url(:reply_rolls, :edit, :id => @reply_roll.id))
    else
      @title = pat(:create_title, :model => 'reply_roll')
      flash.now[:error] = pat(:create_error, :model => 'reply_roll')
      render 'reply_rolls/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "reply_roll #{params[:id]}")
    @reply_roll = ReplyRoll.find(params[:id])
    if @reply_roll
      render 'reply_rolls/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'reply_roll', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "reply_roll #{params[:id]}")
    @reply_roll = ReplyRoll.find(params[:id])
    if @reply_roll
      if @reply_roll.update_attributes(params[:reply_roll])
        flash[:success] = pat(:update_success, :model => 'Reply_roll', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:reply_rolls, :index)) :
          redirect(url(:reply_rolls, :edit, :id => @reply_roll.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'reply_roll')
        render 'reply_rolls/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'reply_roll', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Reply_rolls"
    reply_roll = ReplyRoll.find(params[:id])
    if reply_roll
      if reply_roll.destroy
        flash[:success] = pat(:delete_success, :model => 'Reply_roll', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'reply_roll')
      end
      redirect url(:reply_rolls, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'reply_roll', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Reply_rolls"
    unless params[:reply_roll_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'reply_roll')
      redirect(url(:reply_rolls, :index))
    end
    ids = params[:reply_roll_ids].split(',').map(&:strip)
    reply_rolls = ReplyRoll.find(ids)
    
    if ReplyRoll.destroy reply_rolls
    
      flash[:success] = pat(:destroy_many_success, :model => 'Reply_rolls', :ids => "#{ids.join(', ')}")
    end
    redirect url(:reply_rolls, :index)
  end
end
