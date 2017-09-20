Openpbp::Admin.controllers :replies do
  get :index do
    @title = "Replies"
    @replies = Reply.all
    render 'replies/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'reply')
    @reply = Reply.new
    render 'replies/new'
  end

  post :create do
    @reply = Reply.new(params[:reply])
    if @reply.save
      @title = pat(:create_title, :model => "reply #{@reply.id}")
      flash[:success] = pat(:create_success, :model => 'Reply')
      params[:save_and_continue] ? redirect(url(:replies, :index)) : redirect(url(:replies, :edit, :id => @reply.id))
    else
      @title = pat(:create_title, :model => 'reply')
      flash.now[:error] = pat(:create_error, :model => 'reply')
      render 'replies/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "reply #{params[:id]}")
    @reply = Reply.find(params[:id])
    if @reply
      render 'replies/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'reply', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "reply #{params[:id]}")
    @reply = Reply.find(params[:id])
    if @reply
      if @reply.update_attributes(params[:reply])
        flash[:success] = pat(:update_success, :model => 'Reply', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:replies, :index)) :
          redirect(url(:replies, :edit, :id => @reply.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'reply')
        render 'replies/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'reply', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Replies"
    reply = Reply.find(params[:id])
    if reply
      if reply.destroy
        flash[:success] = pat(:delete_success, :model => 'Reply', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'reply')
      end
      redirect url(:replies, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'reply', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Replies"
    unless params[:reply_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'reply')
      redirect(url(:replies, :index))
    end
    ids = params[:reply_ids].split(',').map(&:strip)
    replies = Reply.find(ids)
    
    if Reply.destroy replies
    
      flash[:success] = pat(:destroy_many_success, :model => 'Replies', :ids => "#{ids.join(', ')}")
    end
    redirect url(:replies, :index)
  end
end
