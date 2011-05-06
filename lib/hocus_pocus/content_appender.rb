module HocusPocus
  class ContentAppender
    def initialize(app)
      @app = app
    end

    def call(env)
#       controller.flash[HocusPocus::SPEC] = controller.params[HocusPocus::SPEC] if controller.params[HocusPocus::SPEC]
#       controller.flash.keep(HocusPocus::SPEC)

    @app.call(env).tap do |status, headers, body|
      if body.respond_to? :body
        @body = body.body
        @controller_name = env['action_dispatch.request.path_parameters'][:controller]
        @action_name = env['action_dispatch.request.path_parameters'][:action]
        unless headers['Content-Type'].starts_with?('text/html')
          #FIXME avoid loading jquery twice
  #         add_jquery
          add_steak_recorder
  #         add_js
          unless controller.start_with? 'hocus_pocus/'
            add_buttons
          end
  #         add_command_line
          body.body = @body
        end
      end
    end

    private
    def add_steak_recorder
      #TODO exclude EDITOR and GENERATOR
      insert_text :before, /<\/body>/i, <<-TEPPAN
<script type="text/javascript">
  $('form').live('submit', function() {
  var scenario = ["  scenario '#{@action_name.humanize} #{@controller_name.humanize}' do"];
  scenario.push("    visit '" + window.location.href + "'");
  $(this).find('input[type=text]').each(function() {
    scenario.push("    fill_in '" + $(this).attr('id') + "', :with => '" + $(this).val() + "'");
  });
  scenario.push("    click_button '" + $(this).find('input[type=submit]').val() + "'");
  $(this).append('<textarea id="#{HocusPocus::SPEC}" name="#{HocusPocus::SPEC}" style="height: 0px; width: 0px;" />');
  $('##{HocusPocus::SPEC}').val(scenario.join('\\n'));
})
</script>
TEPPAN
    end

    def add_buttons
      #FIXME path
      #FIXME use @template somehow?
      edit_link = %Q[<a href="/editor?template=#{@controller.controller_name}/#{@controller.action_name}" data-remote="true" onclick="$(this).closest('div').find('div.partials').toggle()">edit</a>]
      spec_link = %Q[<a href="#" onclick="$(this).closest('div').find('div.spec').toggle();">spec</a>]
      partials = %Q[<div class="partials" style="display:none">#{(Thread.current[HocusPocus::VIEW_FILENAMES] || []).map(&:virtual_path).map {|v| '<a href="/editor?template=' + v + '" data-remote="true">' + v + '</a>'}.join('<br>')}</div>]
      #FIXME more assertions
      spec = %Q[<div class="spec" style="display:none"><pre>#{CGI.unescape(@controller.flash[HocusPocus::SPEC]) + "\n  end" if @controller.flash[HocusPocus::SPEC]}</pre></div>]

      insert_text :before, /<\/body>/i, %Q[<div style="position:absolute; top:0; right: 0;">#{edit_link} | #{spec_link}<br>#{partials}<br>#{spec}</div>]
      Thread.current[HocusPocus::VIEW_FILENAMES] = nil
    end

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
