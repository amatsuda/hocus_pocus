require 'hocus_pocus/editor/engine'

module HocusPocus
  module Editor
    EDITOR = :__hocus_pocus_editor__
    VIEW_FILENAME = :__hocus_pocus_view_filename__
    PARTIAL_FILENAMES = :__hocus_pocus_partial_filenames__

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
            module ::ActionView
              class PartialRenderer
                def render_partial_with_filename_caching
                  (Thread.current[HocusPocus::Editor::PARTIAL_FILENAMES] ||= []) << @template unless @view.controller.class.name.starts_with?('HocusPocus::')
                  render_partial_without_filename_caching
                end
                alias_method_chain :render_partial, :filename_caching
              end

              class TemplateRenderer
                def render_template_with_filename_caching(template, layout_name = nil, locals = {})
                  Thread.current[HocusPocus::Editor::VIEW_FILENAME] = template.virtual_path if @view.controller.try(:request).try(:format).try(:html?) && !@view.controller.class.name.starts_with?('HocusPocus::')
                  render_template_without_filename_caching template, layout_name, locals
                end
                alias_method_chain :render_template, :filename_caching
              end
            end
          end
        end
      end
    end
  end
end
