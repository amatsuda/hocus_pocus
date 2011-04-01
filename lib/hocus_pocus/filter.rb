module HocusPocus
  class Filter
    attr_reader :body

    def self.before(controller)
      controller.flash[HocusPocus::SPEC] = controller.params[HocusPocus::SPEC] if controller.params[HocusPocus::SPEC]
      controller.flash.keep(HocusPocus::SPEC)
    end

    def self.after(controller)
      unless controller.request.format.js?
        filter = self.new(controller)
        #FIXME avoid loading jquery twice
#         filter.add_jquery
        filter.add_steak_recorder
#         filter.add_js
        unless controller.is_a?(HocusPocus::EditorController) || controller.is_a?(HocusPocus::GeneratorController)
          filter.add_buttons
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
      insert_text :before, /<\/head>/i, '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>'
    end

    def add_steak_recorder
      #TODO exclude EDITOR and GENERATOR
      insert_text :before, /<\/body>/i, <<-TEPPAN
<script type="text/javascript">
  $('form').live('submit', function() {
  var scenario = ["  scenario '#{@controller.action_name.humanize} #{@controller.controller_name.humanize}' do"];
  scenario.push("    visit '" + window.location.href + "'");
  $(this).find('input[type=text],textarea').each(function() {
    scenario.push("    fill_in '" + $(this).attr('id') + "', :with => '" + $(this).val() + "'");
  });
  $(this).find('select').each(function() {
    scenario.push("    select '" + $(this).val() + "', :from => '" + $(this).attr('id') + "'");
  });
  scenario.push("    click_button '" + $(this).find('input[type=submit]').val() + "'");
  $(this).append('<textarea id="#{HocusPocus::SPEC}" name="#{HocusPocus::SPEC}" style="height: 0px; width: 0px;" />');
  $('##{HocusPocus::SPEC}').val(scenario.join('\\n'));
})
</script>
TEPPAN
    end


    def add_js
#       insert_text :before, /<\/body>/i, %Q[<script type="text/javascript">alert('hoge!');</script>]
    end

    def add_buttons
      #FIXME path
      #FIXME use @template somehow?
      edit_link = %Q[<a href="/editor?template=#{@controller.controller_name}/#{@controller.action_name}" data-remote="true" onclick="$(this).closest('div').find('div.partials').toggle()">edit</a>]
      spec_link = %Q[<a href="#" onclick="$(this).closest('div').find('div.spec').toggle();">spec</a>]
      partials = %Q[<div class="partials" style="display:none">#{(Thread.current[HocusPocus::VIEW_FILENAMES] || []).map(&:virtual_path).map {|v| '<a href="/editor?template=' + v + '" data-remote="true">' + v + '</a>'}.join('<br>')}</div>]
      #FIXME more assertions
      spec = %Q[<div class="spec" style="display:none"><pre>#{CGI.unescape(@controller.flash[HocusPocus::SPEC]) + "\n  end" if @controller.flash[HocusPocus::SPEC]}</pre><div align="right"><a href="/spec?_method=delete" data-remote="true" data-method="delete">Clear</a></div></div>]

      insert_text :before, /<\/body>/i, %Q[<div id="#{HocusPocus::CONTAINER}" style="position:absolute; top:0; right: 0; font-size: small;">#{edit_link} | #{spec_link}<br>#{partials}<br>#{spec}</div>]
      Thread.current[HocusPocus::VIEW_FILENAMES] = nil
    end

    def add_command_line
      insert_text :before, /<\/body>/i, %Q[<div style="position:absolute; bottom:0;"><form method="post" action="/generator/execute" data-remote="true"><input type="text" name="command" placeholder="Command?" style="width: 512px;" /><input type="submit" name="run" /></form></div>]
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
