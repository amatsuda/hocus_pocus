module HocusPocus
  class Filter
    attr_reader :body

    def self.after(controller)
      unless controller.request.format.js?
        filter = self.new(controller)
        #FIXME avoid loading jquery twice
#         filter.add_jquery
#         filter.add_js
        unless controller.is_a?(HocusPocus::EditorController) || controller.is_a?(HocusPocus::GeneratorController)
          filter.add_edit_button
          filter.add_spec_button
        end
#         filter.add_command_line
        controller.response.body = filter.body
      end
    end

    def initialize(controller)
      @controller = controller
      @template = controller.instance_variable_get(:@template)
      @body = controller.response.body
    end

    def add_jquery
#       insert_text :before, /<\/head>/i, '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script><script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js"></script><link rel="stylesheet" href="/hocus_pocus/stylesheets/jquery.ui.dialog.css" type="text/css">'
      insert_text :before, /<\/head>/i, '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>'
    end

    def add_js
#       insert_text :before, /<\/body>/i, %Q[<script type="text/javascript">alert('hoge!');</script>]
    end

    def add_dialog
      insert_text :before, /<\/body>/i, %Q[<div id="__test_dialog" class="vader">hello, world</div>]
#       controller.response.body += 'added by filter'
    end

    def add_edit_button
      #FIXME path
      #FIXME use @template somehow?
      edit_link = %Q[<a href="/editor?template=#{@controller.controller_name}/#{@controller.action_name}" data-remote="true" onclick="$(this).closest('div').find('div.partials').show()">edit</a>]
      spec_link = %Q[<a href="#" onclick="$(this).closest('div').find('div.spec').show();">spec</a>]
      partials = %Q[<div class="partials" style="display:none">#{(Thread.current[HocusPocus::VIEW_FILENAMES] || []).map(&:virtual_path).map {|v| '<a href="/editor?template=' + v + '" data-remote="true">' + v + '</a>'}.join('<br>')}</div>]
      spec = %Q[<div class="spec" style="display:none"></div>]

      insert_text :before, /<\/body>/i, %Q[<div style="position:absolute; top:0; right: 0;">#{edit_link}<br>#{partials}</div>]
      Thread.current[HocusPocus::VIEW_FILENAMES] = nil
    end

    def add_spec_generator
      insert_text :before, /<\/body>/i, %Q[$('form').live('submit', function() {
      });]
    end

    def add_command_line
      insert_text :before, /<\/body>/i, %Q[<div style="position:absolute; bottom:0;"><form method="post" action="/generator/execute" data-remote="true"><input type="text" name="command" placeholder="どうする？コマンド" style="width: 512px;" /><input type="submit" name="run" /></form></div>]
    end

    private
    def insert_text(position, pattern, new_text)
      index = case pattern
        when Regexp
          if match = @body.match(pattern)
            match.offset(0)[position == :before ? 0 : 1]
          else
            @body.size
          end
        else
          pattern
        end
      @body.insert index, new_text
    end
  end
end
