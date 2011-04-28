module HocusPocus
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<DESC
Description:
    Copies hobus_pocus configuration file to your application's initializer directory.
DESC

      def copy_config_file
        template 'hocus_pocus_config.rb', 'config/initializers/hocus_pocus_config.rb'
      end
    end
  end
end
