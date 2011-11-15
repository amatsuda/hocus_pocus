HocusPocus::CommandLine::Engine.routes.draw do
  post '/execute', :to => 'command_line#execute'
end
