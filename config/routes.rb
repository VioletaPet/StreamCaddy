Rails.application.routes.draw do
  devise_for :users
  root to: "user_providers#index"
  get '/show', to: "users#show", as: 'show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "media/search", to: "media#search", as: 'media_search'
  resources :media, only: [:index, :new, :show]
    get '/media/new/:id', to: 'media#create', as: :new_media
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "media/search", to: "media#search"
  get "actor/show", to: "actor#show"
  # Defines the root path route ("/")
  # root "posts#index"
  resources :watchlist_media, only: [:index, :show, :create, :destroy]
  resources :user_providers, only: [:index, :create, :destroy]
  get "user_providers/select", to: "user_providers#select"
  get "game", to: "games#index", as: :game
  post "game/like", to: "games#like", as: :game_like
  post "game/dislike", to: "games#dislike", as: :game_dislike
  post "game/skip", to: "games#skip", as: :game_skip
end
