module HocusPocus
  module MiddlewareUtil
    def insert_text(body, position, pattern, new_text)
      index = case pattern
        when Regexp
          if match = body.match(pattern)
            match.offset(0)[position == :before ? 0 : 1]
          else
            body.size
          end
        else
          pattern
        end
      body.insert index, new_text
    end
  end
end
