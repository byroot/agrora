Agrora::Application.routes.draw do
  
  namespace :admin do
    resources :servers do
      resources :groups
    end
  end
  
end
