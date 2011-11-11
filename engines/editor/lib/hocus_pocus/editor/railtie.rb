require 'hocus_pocus/editor/engine'

module HocusPocus
  module Editor
    EDITOR = :__hocus_pocus_editor__

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus_editor' do |app|
        ActiveSupport.on_load(:after_initialize) do
          Rails.application.routes.append do
            mount HocusPocus::Editor::Engine, :at => '/'
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
