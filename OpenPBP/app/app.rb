module Openpbp
  class App < Padrino::Application
    use ConnectionPoolManagement
    use Rack::Protection
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Flash
    enable :sessions

    configure :development do
      require 'bullet'
      Bullet.enable = true
      Bullet.bullet_logger = true
      Bullet.console = true
      use Bullet::Rack
    end

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 500 do
    #     render 'errors/500'
    #   end
    #
  end
end
