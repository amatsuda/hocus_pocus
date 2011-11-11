module HocusPocus
  module Editor
    class Engine < ::Rails::Engine
      isolate_namespace HocusPocus::Editor
#         return nil unless HocusPocus.config.enable_editor
    end
  end
end
