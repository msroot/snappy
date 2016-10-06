Rails.application.routes.draw do
  # devise_for :users
  
  # require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'

  
  resources :pages do
    member do
      get 'import'
    end
    
    collection do
      get 'import_all'
    end
    
  end
  resources :events, only: [:show, :index]
  root to: "events#index"
end
