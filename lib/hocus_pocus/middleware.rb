require 'hocus_pocus/middleware_util'

module HocusPocus
  class Middleware
    include MiddlewareUtil

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env).tap do |status, headers, body|
        if body.is_a?(ActionDispatch::Response) && (body.request.path !~ %r[^/*hocus_pocus/])
          body.body = insert_text body.body, :before, /<\/body>/i, %Q[<div id="#{HocusPocus::CONTAINER}" style="position:absolute; top:0; right: 0; font-size: small;"></div>]
        end
      end
    end
  end
end
