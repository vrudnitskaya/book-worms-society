Rails.application.routes.draw do
  root "home#index"
  resources :users do
    member do
      get "followers"
      get "following"
    end
  end
  resources :posts do
    resources :post_tags, only: [ :index, :create, :destroy ]
  end
  resources :comments
  resources :tags, only: [ :index, :show, :create, :destroy ]
  resources :likes, only: [ :index, :create, :destroy ]
  resources :bookmarks, only: [ :index, :create, :destroy ]
  resources :follows, only: [ :index, :create, :destroy ]
  resources :tag_follows, only: [ :index, :create, :destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
