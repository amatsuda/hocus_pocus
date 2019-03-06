require 'hocus_pocus/middleware_util'

module HocusPocus
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

        body.sub!(/<\/body>/i) { %Q[<div id="#{HocusPocus::CONTAINER}" style="position:absolute; top:0; right: 0;"><link href="/assets/recorder.css" media="all" rel="stylesheet" type="text/css"></div>#{$~}] }

        [status, headers, [body]]
      else
        [status, headers, body]
      end
    end
  end
end
