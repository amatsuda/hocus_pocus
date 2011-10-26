require 'hocus_pocus/generator/engine'

module HocusPocus
  module Generator
    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus.generator' do |app|
        ActiveSupport.on_load(:after_initialize) do
          if HocusPocus.config.enable_generator
            Rails.application.routes.append do
              mount HocusPocus::Generator::Engine, :at => '/'
            end
          end
        end

        ActiveSupport.on_load(:action_view) do
          if HocusPocus.config.enable_generator
            class ::ActionView::Base
              def method_missing(method, args = {}, &blk)
                if method.to_s =~ /(new_|edit_)?(.*)(_path|_url)\z/
                  # to avoid DoubleRenderError
                  controller.instance_variable_set :@_response_body, nil
                  #FIXME preserve args
                  controller.redirect_to "/#{$2.pluralize}?return_path=#{method}(#{args})"
                else
                  super
                end
              end
            end
          end
        end
      end
    end
  end
end
