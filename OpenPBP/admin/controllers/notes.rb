Openpbp::Admin.controllers :notes do
  get :index do
    @title = "Notes"
    @notes = Note.all
    render 'notes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'note')
    @note = Note.new
    render 'notes/new'
  end

  post :create do
    @note = Note.new(params[:note])
    if @note.save
      @title = pat(:create_title, :model => "note #{@note.id}")
      flash[:success] = pat(:create_success, :model => 'Note')
      params[:save_and_continue] ? redirect(url(:notes, :index)) : redirect(url(:notes, :edit, :id => @note.id))
    else
      @title = pat(:create_title, :model => 'note')
      flash.now[:error] = pat(:create_error, :model => 'note')
      render 'notes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "note #{params[:id]}")
    @note = Note.find(params[:id])
    if @note
      render 'notes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "note #{params[:id]}")
    @note = Note.find(params[:id])
    if @note
      if @note.update_attributes(params[:note])
        flash[:success] = pat(:update_success, :model => 'Note', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:notes, :index)) :
          redirect(url(:notes, :edit, :id => @note.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'note')
        render 'notes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Notes"
    note = Note.find(params[:id])
    if note
      if note.destroy
        flash[:success] = pat(:delete_success, :model => 'Note', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'note')
      end
      redirect url(:notes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Notes"
    unless params[:note_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'note')
      redirect(url(:notes, :index))
    end
    ids = params[:note_ids].split(',').map(&:strip)
    notes = Note.find(ids)
    
    if Note.destroy notes
    
      flash[:success] = pat(:destroy_many_success, :model => 'Notes', :ids => "#{ids.join(', ')}")
    end
    redirect url(:notes, :index)
  end
end
