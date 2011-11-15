require 'rails/generators'
require 'active_record/schema_dumper'

module HocusPocus
  module Generator
    class GeneratorController < ActionController::Base
      def index
        @name = params[:anything]
      end

      # XHR
      def execute
        #FIXME validate params
        `#{params[:command]}`
        flash.now[:notice] = "successfully executed: #{params[:command]}"
      end

      # XHR
      def scaffold
        #FIXME validate params
        p options = params[:attr].select {|_k, v| v.present?}.map {|k, v| "#{v}:#{params[:type][k]}"}
        execute_scaffold params[:name].dup, options
        migrate
        #FIXME notice doesn't appear?
  #       @return_path = '/' + (params[:return_path].present? ? params[:return_path] : params[:name])
        @return_path = '/' + params[:name]
        flash.now[:notice] = "successfully generated #{params[:name]} scaffold!"
  #       redirect_to "/#{return_path}", :notice => "successfully generated #{params[:name]} scaffold!"
      end

      private
      def execute_scaffold(name, options)
        overwriting_argv([name, options]) do
          cmd = name.include?('/') ? 'nested_scaffold' : 'scaffold'
          Rails::Generators.configure! Rails.application.config.generators
          Rails::Generators.invoke cmd, [name, options], :behavior => :invoke, :destination_root => Rails.root
        end
      end

      # `rake db:migrate`
      def migrate
        ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
        if ActiveRecord::Base.schema_format == :ruby
          File.open(ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb", "w") do |file|
            ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
          end
        end
      end

      # a dirty workaround to make rspec-rails run
      def overwriting_argv(value, &block)
        original_argv = ARGV
        Object.const_set :ARGV, value
        block.call
      ensure
        Object.const_set :ARGV, original_argv
      end
    end
  end
end
