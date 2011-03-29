Rails::Application.routes.draw do
  post '/generator/scaffold', :to => 'generator#scaffold', :as => 'scaffold_generator'
  post '/generator/execute', :to => 'generator#execute', :as => 'execute_generator'
  get '/editor', :to => 'editor#index'
  post '/editor/save', :to => 'editor#save', :as => 'save_editor'
  get '/:anything', :to => 'generator#index', :constraints => {:anything => /.*/}
end
