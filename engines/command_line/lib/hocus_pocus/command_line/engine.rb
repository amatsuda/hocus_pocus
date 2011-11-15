require 'hocus_pocus/command_line/middleware'

module HocusPocus
  module CommandLine
    class Engine < ::Rails::Engine
      isolate_namespace HocusPocus::CommandLine

      initializer 'hocus_pocus.command_line.add middleware' do |app|
        if HocusPocus.config.enable_command_line
          app.middleware.insert HocusPocus::Middleware, HocusPocus::CommandLine::Middleware
        end
      end
    end
  end
end
