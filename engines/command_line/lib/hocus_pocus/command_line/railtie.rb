require 'hocus_pocus/command_line/engine'

module HocusPocus
  module CommandLine
    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus.command_line' do |app|
        ActiveSupport.on_load(:after_initialize) do
          if HocusPocus.config.enable_command_line
            Rails.application.routes.append do
              mount HocusPocus::CommandLine::Engine, :at => '/hocus_pocus/command_line'
            end
          end
        end
      end
    end
  end
end
