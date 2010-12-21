module HocusPocus
  module GeneratorHelper
    def type_select(field_name, options = {})
      select_tag field_name, options_for_select(%w[string text integer float decimal datetime time date boolean references]), options
    end
  end
end
