require 'hocus_pocus/middleware_util'

module HocusPocus
  module Recorder
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
          body.sub!(/<\/head>/i) { %Q[<script src="/assets/recorder.js"></script></head>] }
          body.sub!(/<div id="#{HocusPocus::CONTAINER}" .*?>/i) { %Q[#{$~}#{spec_link}#{spec}] }

          [status, headers, [body]]
        else
          [status, headers, body]
        end
      end

      private
      def spec_link
        %Q[<a href="/hocus_pocus/recorder" data-remote="true" class="spec">spec</a>]
      end

      def spec
        #FIXME more assertions
        %Q[<div class="spec" style="display:none"><div align="right"><a href="/hocus_pocus/recorder" data-remote="true" data-method="delete" class="clear">Clear</a></div></div>]
      end
    end
  end
end
