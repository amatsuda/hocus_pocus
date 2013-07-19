require 'hocus_pocus/middleware_util'

module HocusPocus
  module Recorder
    class Middleware
      include MiddlewareUtil

      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env).tap do |status, headers, body|
          if body.is_a?(ActionDispatch::Response) && body.request.format.html? && (body.request.path !~ %r[^/*hocus_pocus/])
            body.body = insert_text body.body, :before, /<\/head>/i, %Q[<script src="/assets/recorder.js"></script>]
            body.body = insert_text body.body, :after, /<div id="#{HocusPocus::CONTAINER}" .*?>/i, %Q[#{spec_link}#{spec}]
          end
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
