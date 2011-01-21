Agrora::Application.routes.draw do
  
  namespace :admin do
    resources :servers, :constraints => { :id => /[a-zA-Z0-9\.\-]+/} do
      resources :groups
    end
  end
  
  resources :groups, :constraints => { :id => /[a-z\.]+/} do
    resources :topics, :constraints => { :id => /[a-f0-9]+/}
  end
  
  root :to => 'groups#index'
  
end
