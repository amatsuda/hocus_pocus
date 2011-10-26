HocusPocus::Generator::Engine.routes.draw do
  post '/hocus_pocus/generator/scaffold', :to => 'generator#scaffold', :as => 'scaffold_generator'

  get '/:anything', :to => 'generator#index', :constraints => {:anything => /.*/}
end
