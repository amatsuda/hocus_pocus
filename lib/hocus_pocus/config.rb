require 'active_support/configurable'

module HocusPocus
  # Configures global settings for HocusPocus
  #   HocusPocus.configure do |config|
  #     config.enable_generator = false
  #   end
  def self.configure(&block)
    yield @config ||= HocusPocus::Configuration.new
  end

  # Global settings for HocusPocus
  def self.config
    @config
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :enable_generator, :enable_editor, :enable_scenario_recorder, :enable_command_line
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.enable_generator = true
    config.enable_editor = true
    config.enable_scenario_recorder = true
    config.enable_command_line = false
  end
end
