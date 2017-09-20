Openpbp::Admin.controllers :chapters do
  get :index do
    @title = "Chapters"
    @chapters = Chapter.all
    render 'chapters/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'chapter')
    @chapter = Chapter.new
    render 'chapters/new'
  end

  post :create do
    @chapter = Chapter.new(params[:chapter])
    if @chapter.save
      @title = pat(:create_title, :model => "chapter #{@chapter.id}")
      flash[:success] = pat(:create_success, :model => 'Chapter')
      params[:save_and_continue] ? redirect(url(:chapters, :index)) : redirect(url(:chapters, :edit, :id => @chapter.id))
    else
      @title = pat(:create_title, :model => 'chapter')
      flash.now[:error] = pat(:create_error, :model => 'chapter')
      render 'chapters/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "chapter #{params[:id]}")
    @chapter = Chapter.find(params[:id])
    if @chapter
      render 'chapters/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'chapter', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "chapter #{params[:id]}")
    @chapter = Chapter.find(params[:id])
    if @chapter
      if @chapter.update_attributes(params[:chapter])
        flash[:success] = pat(:update_success, :model => 'Chapter', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:chapters, :index)) :
          redirect(url(:chapters, :edit, :id => @chapter.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'chapter')
        render 'chapters/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'chapter', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Chapters"
    chapter = Chapter.find(params[:id])
    if chapter
      if chapter.destroy
        flash[:success] = pat(:delete_success, :model => 'Chapter', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'chapter')
      end
      redirect url(:chapters, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'chapter', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Chapters"
    unless params[:chapter_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'chapter')
      redirect(url(:chapters, :index))
    end
    ids = params[:chapter_ids].split(',').map(&:strip)
    chapters = Chapter.find(ids)
    
    if Chapter.destroy chapters
    
      flash[:success] = pat(:destroy_many_success, :model => 'Chapters', :ids => "#{ids.join(', ')}")
    end
    redirect url(:chapters, :index)
  end
end
