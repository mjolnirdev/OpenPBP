Openpbp::Admin.controllers :scenes do
  get :index do
    @title = "Scenes"
    @scenes = Scene.all
    render 'scenes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'scene')
    @scene = Scene.new
    render 'scenes/new'
  end

  post :create do
    @scene = Scene.new(params[:scene])
    if @scene.save
      @title = pat(:create_title, :model => "scene #{@scene.id}")
      flash[:success] = pat(:create_success, :model => 'Scene')
      params[:save_and_continue] ? redirect(url(:scenes, :index)) : redirect(url(:scenes, :edit, :id => @scene.id))
    else
      @title = pat(:create_title, :model => 'scene')
      flash.now[:error] = pat(:create_error, :model => 'scene')
      render 'scenes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "scene #{params[:id]}")
    @scene = Scene.find(params[:id])
    if @scene
      render 'scenes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'scene', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "scene #{params[:id]}")
    @scene = Scene.find(params[:id])
    if @scene
      if @scene.update_attributes(params[:scene])
        flash[:success] = pat(:update_success, :model => 'Scene', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:scenes, :index)) :
          redirect(url(:scenes, :edit, :id => @scene.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'scene')
        render 'scenes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'scene', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Scenes"
    scene = Scene.find(params[:id])
    if scene
      if scene.destroy
        flash[:success] = pat(:delete_success, :model => 'Scene', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'scene')
      end
      redirect url(:scenes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'scene', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Scenes"
    unless params[:scene_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'scene')
      redirect(url(:scenes, :index))
    end
    ids = params[:scene_ids].split(',').map(&:strip)
    scenes = Scene.find(ids)
    
    if Scene.destroy scenes
    
      flash[:success] = pat(:destroy_many_success, :model => 'Scenes', :ids => "#{ids.join(', ')}")
    end
    redirect url(:scenes, :index)
  end
end
