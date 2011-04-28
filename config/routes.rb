HocusPocus::Engine.routes.draw do
  if HocusPocus.config.enable_generator
    post '/generator/scaffold', :to => 'generator#scaffold', :as => 'scaffold_generator'
    post '/generator/execute', :to => 'generator#execute', :as => 'execute_generator'
  end
  if HocusPocus.config.enable_editor
    get '/editor', :to => 'editor#index'
    post '/editor/save', :to => 'editor#save', :as => 'save_editor'
  end
  if HocusPocus.config.enable_scenario_recorder
    delete '/spec', :to => 'spec#destroy'
  end
  if HocusPocus.config.enable_generator
    get '/:anything', :to => 'generator#index', :constraints => {:anything => /.*/}
  end
end
