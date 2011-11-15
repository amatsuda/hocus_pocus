require 'hocus_pocus/middleware_util'

module HocusPocus
  module CommandLine
    class Middleware
      include MiddlewareUtil

      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env).tap do |status, headers, body|
          if body.is_a?(ActionDispatch::Response) && body.request.format.html?
            body.body = insert_text body.body, :after, /<div id="#{HocusPocus::CONTAINER}" .*?>/i, command_line_link
          end
        end
      end

      private
      def command_line_link
        %Q[<a href="#" onclick="$(this).closest('div').find('div.command_line_form').toggle()">cmd</a><div class="command_line_form" style="display:none;"><form method="post" action="/hocus_pocus/command_line/execute" data-remote="true"><input type="text" name="command" placeholder="Command?" style="width: 512px;" /><input type="submit" name="run" /></form></div>]
      end
    end
  end
end
