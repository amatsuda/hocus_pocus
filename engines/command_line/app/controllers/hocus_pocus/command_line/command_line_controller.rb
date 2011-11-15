module HocusPocus
  module CommandLine
    class CommandLineController < ActionController::Base
      # XHR
      def execute
        #FIXME validate params
        `#{params[:command]}`
        flash.now[:notice] = "successfully executed: #{params[:command]}"
      end
    end
  end
end
