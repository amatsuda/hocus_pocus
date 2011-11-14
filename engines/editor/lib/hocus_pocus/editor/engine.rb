require 'hocus_pocus/editor/middleware'

module HocusPocus
  module Editor
    class Engine < ::Rails::Engine
      isolate_namespace HocusPocus::Editor

      initializer 'hocus_pocus.editor.add middleware' do |app|
        if HocusPocus.config.enable_editor
          app.middleware.insert HocusPocus::Middleware, HocusPocus::Editor::Middleware
        end
      end
    end
  end
end
