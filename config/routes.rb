HocusPocus::Engine.routes.draw do
  if HocusPocus.config.enable_editor
    get '/editor', :to => 'editor#index'
    post '/editor/save', :to => 'editor#save', :as => 'save_editor'
  end
  if HocusPocus.config.enable_scenario_recorder
    delete '/spec', :to => 'spec#destroy'
  end
end
