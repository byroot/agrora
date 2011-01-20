Agrora::Application.routes.draw do
  
  namespace :admin do
    resources :servers, :constraints => { :id => /[a-zA-Z0-9\.\-]+/} do
      resources :groups
    end
  end
  
end
