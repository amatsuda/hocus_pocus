require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'

  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require 'rspec/rails'
  
  RSpec.configure do |config|
    config.mock_with :rspec
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.
end