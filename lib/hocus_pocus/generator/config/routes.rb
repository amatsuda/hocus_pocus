HocusPocus::Generator::Engine.routes.draw do
  post '/generator/scaffold', :to => 'generator#scaffold', :as => 'scaffold_generator'
  post '/generator/execute', :to => 'generator#execute', :as => 'execute_generator'

  get '/:anything', :to => 'generator#index', :constraints => {:anything => /.*/}
end
