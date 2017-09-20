Openpbp::Admin.controllers :post_rolls do
  get :index do
    @title = "Post_rolls"
    @post_rolls = PostRoll.all
    render 'post_rolls/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'post_roll')
    @post_roll = PostRoll.new
    render 'post_rolls/new'
  end

  post :create do
    @post_roll = PostRoll.new(params[:post_roll])
    if @post_roll.save
      @title = pat(:create_title, :model => "post_roll #{@post_roll.id}")
      flash[:success] = pat(:create_success, :model => 'PostRoll')
      params[:save_and_continue] ? redirect(url(:post_rolls, :index)) : redirect(url(:post_rolls, :edit, :id => @post_roll.id))
    else
      @title = pat(:create_title, :model => 'post_roll')
      flash.now[:error] = pat(:create_error, :model => 'post_roll')
      render 'post_rolls/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "post_roll #{params[:id]}")
    @post_roll = PostRoll.find(params[:id])
    if @post_roll
      render 'post_rolls/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'post_roll', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "post_roll #{params[:id]}")
    @post_roll = PostRoll.find(params[:id])
    if @post_roll
      if @post_roll.update_attributes(params[:post_roll])
        flash[:success] = pat(:update_success, :model => 'Post_roll', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:post_rolls, :index)) :
          redirect(url(:post_rolls, :edit, :id => @post_roll.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'post_roll')
        render 'post_rolls/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'post_roll', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Post_rolls"
    post_roll = PostRoll.find(params[:id])
    if post_roll
      if post_roll.destroy
        flash[:success] = pat(:delete_success, :model => 'Post_roll', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'post_roll')
      end
      redirect url(:post_rolls, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'post_roll', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Post_rolls"
    unless params[:post_roll_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'post_roll')
      redirect(url(:post_rolls, :index))
    end
    ids = params[:post_roll_ids].split(',').map(&:strip)
    post_rolls = PostRoll.find(ids)
    
    if PostRoll.destroy post_rolls
    
      flash[:success] = pat(:destroy_many_success, :model => 'Post_rolls', :ids => "#{ids.join(', ')}")
    end
    redirect url(:post_rolls, :index)
  end
end
