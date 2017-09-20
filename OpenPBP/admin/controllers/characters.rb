Openpbp::Admin.controllers :characters do
  get :index do
    @title = "Characters"
    @characters = Character.all
    render 'characters/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'character')
    @character = Character.new
    render 'characters/new'
  end

  post :create do
    @character = Character.new(params[:character])
    if @character.save
      @title = pat(:create_title, :model => "character #{@character.id}")
      flash[:success] = pat(:create_success, :model => 'Character')
      params[:save_and_continue] ? redirect(url(:characters, :index)) : redirect(url(:characters, :edit, :id => @character.id))
    else
      @title = pat(:create_title, :model => 'character')
      flash.now[:error] = pat(:create_error, :model => 'character')
      render 'characters/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "character #{params[:id]}")
    @character = Character.find(params[:id])
    if @character
      render 'characters/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'character', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "character #{params[:id]}")
    @character = Character.find(params[:id])
    if @character
      if @character.update_attributes(params[:character])
        flash[:success] = pat(:update_success, :model => 'Character', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:characters, :index)) :
          redirect(url(:characters, :edit, :id => @character.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'character')
        render 'characters/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'character', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Characters"
    character = Character.find(params[:id])
    if character
      if character.destroy
        flash[:success] = pat(:delete_success, :model => 'Character', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'character')
      end
      redirect url(:characters, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'character', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Characters"
    unless params[:character_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'character')
      redirect(url(:characters, :index))
    end
    ids = params[:character_ids].split(',').map(&:strip)
    characters = Character.find(ids)
    
    if Character.destroy characters
    
      flash[:success] = pat(:destroy_many_success, :model => 'Characters', :ids => "#{ids.join(', ')}")
    end
    redirect url(:characters, :index)
  end
end
