Openpbp::App.controllers :static do
  get :root, :map => '/', priority: :high do
    if session[:user_id]
      redirect "/campaigns"
    else
      render 'static/index'
    end
  end

  get :about, :map => 'about', priority: :high do
    render 'static/about'
  end

  get :contact, :map => 'contact', priority: :high do
    render 'static/contact'
  end

  get :faq, :map => 'faq', priority: :high do
    render 'static/faq'
  end

  get :privacy, :map => 'privacy', priority: :high do
    render 'static/privacy'
  end

  get :tos, :map => 'tos', priority: :high do
    render 'static/tos'
  end
end
