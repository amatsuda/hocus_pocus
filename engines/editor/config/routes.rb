HocusPocus::Editor::Engine.routes.draw do
  get '/editor', :to => 'editor#index'
  post '/editor/save', :to => 'editor#save', :as => 'save_editor'
end
