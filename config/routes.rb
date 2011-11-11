HocusPocus::Engine.routes.draw do
  if HocusPocus.config.enable_scenario_recorder
    delete '/spec', :to => 'spec#destroy'
  end
end
