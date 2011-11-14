require 'rails'
require File.join(File.dirname(__FILE__), 'config')

if Rails.env.development?
  require 'hocus_pocus/engine'
#   require 'hocus_pocus/filter'

  module HocusPocus
    CONTAINER = :__hocus_pocus_container__
    SPEC = :__hocus_pocus_spec__

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus' do |app|
        ActiveSupport.on_load(:after_initialize) do
          Rails.application.routes.append do
            mount HocusPocus::Engine, :at => '/'
          end
        end
        ActiveSupport.on_load(:action_controller) do
#           class ::ActionController::Base
#             before_filter HocusPocus::Filter
#             after_filter HocusPocus::Filter
#           end
        end
      end
    end
  end
end
