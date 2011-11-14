HocusPocus::Editor::Engine.routes.draw do
  get '/', :to => 'editor#index'
  post '/save', :to => 'editor#save', :as => 'save_editor'
end
