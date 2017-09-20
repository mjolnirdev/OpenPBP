Openpbp::Admin.controllers :chat_messages do
  get :index do
    @title = "Chat_messages"
    @chat_messages = ChatMessage.all
    render 'chat_messages/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'chat_message')
    @chat_message = ChatMessage.new
    render 'chat_messages/new'
  end

  post :create do
    @chat_message = ChatMessage.new(params[:chat_message])
    if @chat_message.save
      @title = pat(:create_title, :model => "chat_message #{@chat_message.id}")
      flash[:success] = pat(:create_success, :model => 'ChatMessage')
      params[:save_and_continue] ? redirect(url(:chat_messages, :index)) : redirect(url(:chat_messages, :edit, :id => @chat_message.id))
    else
      @title = pat(:create_title, :model => 'chat_message')
      flash.now[:error] = pat(:create_error, :model => 'chat_message')
      render 'chat_messages/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "chat_message #{params[:id]}")
    @chat_message = ChatMessage.find(params[:id])
    if @chat_message
      render 'chat_messages/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'chat_message', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "chat_message #{params[:id]}")
    @chat_message = ChatMessage.find(params[:id])
    if @chat_message
      if @chat_message.update_attributes(params[:chat_message])
        flash[:success] = pat(:update_success, :model => 'Chat_message', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:chat_messages, :index)) :
          redirect(url(:chat_messages, :edit, :id => @chat_message.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'chat_message')
        render 'chat_messages/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'chat_message', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Chat_messages"
    chat_message = ChatMessage.find(params[:id])
    if chat_message
      if chat_message.destroy
        flash[:success] = pat(:delete_success, :model => 'Chat_message', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'chat_message')
      end
      redirect url(:chat_messages, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'chat_message', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Chat_messages"
    unless params[:chat_message_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'chat_message')
      redirect(url(:chat_messages, :index))
    end
    ids = params[:chat_message_ids].split(',').map(&:strip)
    chat_messages = ChatMessage.find(ids)
    
    if ChatMessage.destroy chat_messages
    
      flash[:success] = pat(:destroy_many_success, :model => 'Chat_messages', :ids => "#{ids.join(', ')}")
    end
    redirect url(:chat_messages, :index)
  end
end
