require 'hocus_pocus/recorder/engine'
require 'hocus_pocus/recorder/filter'

module HocusPocus
  module Recorder
    SPEC = :__hocus_pocus_recorder__

    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'hocus_pocus.recorder' do |app|
        ActiveSupport.on_load(:after_initialize) do
          if HocusPocus.config.enable_scenario_recorder
            Rails.application.routes.append do
              mount HocusPocus::Recorder::Engine, :at => '/hocus_pocus/recorder'
            end
          end
        end
        ActiveSupport.on_load(:action_controller) do
          if HocusPocus.config.enable_scenario_recorder
            class ::ActionController::Base
              before_action HocusPocus::Recorder::Filter
            end
          end
        end
      end
    end
  end
end
