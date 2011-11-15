require 'rails'
require 'hocus_pocus/config'

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

  require 'hocus_pocus/editor/railtie'
  require 'hocus_pocus/recorder/railtie'
  require 'hocus_pocus/command_line/railtie'
  # note that the generator should be loaded at the last because it has wildcard routing
  require 'hocus_pocus/generator/railtie'
end
