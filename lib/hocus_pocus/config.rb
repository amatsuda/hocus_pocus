require 'active_support/configurable'

module HocusPocus
  include ActiveSupport::Configurable
  config_accessor :enable_generator, :enable_editor, :enable_scenario_recorder, :enable_command_line

  # Configures global settings for HocusPocus
  #   HocusPocus.configure do |config|
  #     config.enable_generator = false
  #   end
  def self.configure(&block)
    yield self
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.enable_generator = true
    config.enable_editor = true
    config.enable_scenario_recorder = true
    config.enable_command_line = false
  end
end
