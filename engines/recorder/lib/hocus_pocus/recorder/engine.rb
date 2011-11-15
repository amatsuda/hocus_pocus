require 'hocus_pocus/recorder/middleware'

module HocusPocus
  module Recorder
    class Engine < ::Rails::Engine
      isolate_namespace HocusPocus::Recorder

      initializer 'hocus_pocus.recorder.add middleware' do |app|
        if HocusPocus.config.enable_scenario_recorder
          app.middleware.insert HocusPocus::Middleware, HocusPocus::Recorder::Middleware
        end
      end
    end
  end
end
