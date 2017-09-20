Openpbp::App.controllers :users do
  before except: [:login, :signup] do
    restrict_logged_in
  end
  
  get :edit, :map => '/user/edit' do
    render 'users/edit'
  end

  post :edit, :map => '/user/edit' do
    if params[:password].nil?
      @user.update_details(params)
      @user.save
      redirect '/campaigns', notice: 'User account details updated.'
    elsif @user.password == params[:password] && params[:new_password] == params[:new_password_confirmation]
      @user.update_password(params)
      if @user.save
        redirect '/campaigns', notice: 'Password updated.'
      else
        flash.now[:error] = 'There was a problem updating your password.'
        render 'users/edit'
      end
    else
      flash.now[:error] = 'Incorrect current password or mismatched new password, please try again.'
      render 'users/edit'
    end
  end

  get :login, :map => '/login' do
    if session[:user_id]
      redirect '/campaigns', error: 'You are already logged in.'
    else
      render 'users/login', layout: :authentication
    end
  end

  post :login, :map => '/login' do
    if session[:user_id]
      redirect '/campaigns', error: 'You are already logged in.'
    else
      @user = User.find_by_email(params[:email])
      if @user && @user.password == params[:password]
        session[:user_id] = @user.create_session(@request)
        if session[:redirect]
          redirect_url = session[:redirect]
          session.delete(:redirect)
          redirect redirect_url, success: 'Logged in successfully.'
        else
          redirect '/campaigns', success: 'Logged in successfully.'
        end
      else
        flash.now[:error] = 'Incorrect credentials, please try again.'
        render 'users/login', layout: :authentication
      end
    end
  end

  get :logout, :map => '/logout' do
    session.delete(:user_id)
    redirect '/login', notice: 'You have been logged out.'
  end

  get :signup, :map => '/signup' do
    @user = User.new
    render 'users/signup', layout: :authentication
  end

  post :signup, :map => '/signup' do
    # TODO: Email validation.
    # TODO: Password reset.
    if params[:password] == params[:password_confirmation]
      @user = User.new
      @user.create_user(params, request)
      if @user.save
        session[:user_id] = @user.id
        redirect '/campaigns', success: 'Successfully signed up.'
      else
        flash.now[:error] = 'There was a problem with your submission.'
        render 'users/signup', layout: :authentication
      end
    else
      flash.now[:error] = 'Passwords did not match.'
      render 'users/signup', layout: :authentication
    end
  end
end
