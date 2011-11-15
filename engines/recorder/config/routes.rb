HocusPocus::Recorder::Engine.routes.draw do
  get '/', :to => 'recorder#index'
  delete '/', :to => 'recorder#destroy'
end
