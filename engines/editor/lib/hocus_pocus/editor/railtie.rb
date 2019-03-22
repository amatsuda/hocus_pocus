require 'hocus_pocus/editor/engine'

module HocusPocus
  module Editor
    EDITOR = :__hocus_pocus_editor__
    VIEW_FILENAME = :__hocus_pocus_view_filename__
    PARTIAL_FILENAMES = :__hocus_pocus_partial_filenames__

    module PartialRendererExtension
      def render_partial
        (Thread.current[HocusPocus::Editor::PARTIAL_FILENAMES] ||= []) << @template unless @view.controller.class.name.starts_with?('HocusPocus::')
        super
      end
    end

    module TemplateRendererExtension
      if ::ActionView::TemplateRenderer.instance_method(:render_template).arity == 4
        def render_template(view, template, layout_name, locals)
          Thread.current[HocusPocus::Editor::VIEW_FILENAME] = template.virtual_path if view.controller.try(:request).try(:format).try(:html?) && !view.controller.class.name.starts_with?('HocusPocus::')
          super
        end
      else
        def render_template(template, layout_name = nil, locals = {})
          Thread.current[HocusPocus::Editor::VIEW_FILENAME] = template.virtual_path if @view.controller.try(:request).try(:format).try(:html?) && !@view.controller.class.name.starts_with?('HocusPocus::')
          super
        end
      end
    end

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus.editor' do |app|
        ActiveSupport.on_load(:after_initialize) do
          if HocusPocus.config.enable_editor
            Rails.application.routes.append do
              mount HocusPocus::Editor::Engine, :at => '/hocus_pocus/editor'
            end
          end
        end

        ActiveSupport.on_load(:action_view) do
          if HocusPocus.config.enable_editor
            ::ActionView::PartialRenderer.send :prepend, HocusPocus::Editor::PartialRendererExtension
            ::ActionView::TemplateRenderer.send :prepend, HocusPocus::Editor::TemplateRendererExtension
          end
        end
      end
    end
  end
end
