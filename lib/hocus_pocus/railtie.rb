require 'rails'
require File.join(File.dirname(__FILE__), 'config')

if Rails.env.development?
  require 'hocus_pocus/engine'

  module HocusPocus
    CONTAINER = :__hocus_pocus_container__

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus' do |app|
        ActiveSupport.on_load(:after_initialize) do
          Rails.application.routes.append do
            mount HocusPocus::Engine, :at => '/'
          end
        end
      end
    end
  end
end
