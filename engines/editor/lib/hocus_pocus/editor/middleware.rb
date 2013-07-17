require 'hocus_pocus/middleware_util'

module HocusPocus
  module Editor
    class Middleware
      include MiddlewareUtil

      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env).tap do |status, headers, body|
          if body.is_a?(ActionDispatch::Response) && body.request.format.html?
            if Thread.current[HocusPocus::Editor::VIEW_FILENAME]
              body.body = insert_text body.body, :after, /<div id="#{HocusPocus::CONTAINER}" .*?>/i, %Q[#{edit_link}#{partials}]
              Thread.current[HocusPocus::Editor::VIEW_FILENAME] = nil
            end
          end
        end
      end

      private
      def edit_link
        %Q[<a href="/hocus_pocus/editor?template=#{Thread.current[HocusPocus::Editor::VIEW_FILENAME]}" data-remote="true" onclick="$(this).closest('div').find('div.partials').toggle()" class="edit">edit</a>]
      end

      def partials
        %Q[<div class="partials" style="display:none">#{(Thread.current[HocusPocus::Editor::PARTIAL_FILENAMES] || []).map(&:virtual_path).map {|v| '<a href="/hocus_pocus/editor?template=' + v + '" data-remote="true" class="partials">' + v + '</a>'}.join('')}</div>]
      end
    end
  end
end
