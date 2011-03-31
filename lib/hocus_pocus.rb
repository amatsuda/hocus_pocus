if Rails.env.development?
  require 'hocus_pocus/engine'
  require 'hocus_pocus/filter'

  module HocusPocus
    VIEW_FILENAMES = :__hocus_pocus_view_filenames__
    CONTAINER = :__hocus_pocus_container__
    EDITOR = :__hocus_pocus_editor__
    GENERATOR = :__hocus_pocus_generator__
    SPEC = :__hocus_pocus_spec__
  end

#   ActiveSupport.on_load(:after_initialize) do
#     Rails.application.routes.append do
#       mount HocusPocus::Engine, :at => '/'
#     end
#   end

  class ::ActionController::Base
    before_filter HocusPocus::Filter
    after_filter HocusPocus::Filter
  end

  class ::ActionView::Base
    def method_missing(method, args = {}, &blk)
      if method.to_s =~ /(new_|edit_)?(.*)(_path|_url)\z/
        # to avoid DoubleRenderError
        controller.instance_variable_set :@_response_body, nil
        #FIXME preserve args
        controller.redirect_to "/#{$2.pluralize}?return_path=#{method}(#{args})"
      else
        super
      end
    end
  end
end
