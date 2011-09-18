require 'hocus_pocus/generator/engine'

module HocusPocus
  module Generator
    GENERATOR = :__hocus_pocus_generator__

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus_generator' do |app|
        ActiveSupport.on_load(:after_initialize) do
          Rails.application.routes.append do
            mount HocusPocus::Generator::Engine, :at => '/'
          end
        end
      end
    end
  end
end
