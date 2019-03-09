require 'hocus_pocus/middleware_util'

module HocusPocus
  module CommandLine
    class Middleware
      include MiddlewareUtil

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call env

        if headers && headers['Content-Type']&.include?('text/html') && (env['REQUEST_PATH'] !~ %r[^/*hocus_pocus/])
          case body
          when ActionDispatch::Response, ActionDispatch::Response::RackBody
            body = body.body
          when Array
            body = body[0]
          end

          body.sub!(/<\/head>/i) { %Q[<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script></head>] } unless body =~ /jquery(\.min)?\.js/
          body.sub!(/<div id="#{HocusPocus::CONTAINER}" .*?>/i) { %Q[#{$~}#{command_line_link}] }

          [status, headers, [body]]
        else
          [status, headers, body]
        end
      end

      private
      def command_line_link
        %Q[<a href="#" onclick="$(this).closest('div').find('div.command_line_form').toggle(); return false;">cmd</a><div class="command_line_form" style="display:none;"><form method="post" action="/hocus_pocus/command_line/execute" data-remote="true"><input type="text" name="command" placeholder="Command?" style="width: 512px;" /><input type="submit" name="run" /></form></div>]
      end
    end
  end
end
