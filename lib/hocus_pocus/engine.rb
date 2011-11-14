require 'hocus_pocus/middleware'

module HocusPocus
  class Engine < ::Rails::Engine
    isolate_namespace HocusPocus

    initializer 'hocus_pocus.add middleware' do |app|
#       app.middleware.use HocusPocus::RouteMissing
      app.middleware.use HocusPocus::Middleware
    end
  end
end
