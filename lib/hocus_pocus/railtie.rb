require 'rails'
require File.join(File.dirname(__FILE__), 'config')

if Rails.env.development?
  require 'hocus_pocus/engine'
  require 'hocus_pocus/filter'

  module HocusPocus
    VIEW_FILENAMES = :__hocus_pocus_view_filenames__
    CONTAINER = :__hocus_pocus_container__
    EDITOR = :__hocus_pocus_editor__
    SPEC = :__hocus_pocus_spec__

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus' do |app|
        ActiveSupport.on_load(:after_initialize) do
          Rails.application.routes.append do
            mount HocusPocus::Engine, :at => '/'
          end
        end
        ActiveSupport.on_load(:action_controller) do
          class ::ActionController::Base
            before_filter HocusPocus::Filter
            after_filter HocusPocus::Filter
          end
        end
        ActiveSupport.on_load(:action_view) do
          class ::ActionView::PartialRenderer
            def render_partial_with_filename_caching
              (Thread.current[HocusPocus::VIEW_FILENAMES] ||= []) << @template unless @view.controller.class.name.starts_with?('HocusPocus::')
              render_partial_without_filename_caching
            end
            alias_method_chain :render_partial, :filename_caching
          end
        end
      end
    end
  end
end
