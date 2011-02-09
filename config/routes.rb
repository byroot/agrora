Agrora::Application.routes.draw do
  
  namespace :admin do
    root :to => 'base#index'
    resources :servers, :constraints => { :id => /[a-zA-Z0-9\.\-]+/ } do
      resources :groups
    end
  end
  
  resources :groups, :constraints => { :id => /[a-z\.]+/ } do
    resources :topics, :constraints => { :id => /\d+[^\/]*/ } do
      resources :messages
    end
  end

  resources :session
  resources :users
  
  match 'users/activate/:token' => 'users#activate', :as => :user_activate

  root :to => 'groups#index'
  
end
