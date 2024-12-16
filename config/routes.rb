Rails.application.routes.draw do
  devise_for :users
  root to: "user_providers#index"

  # User show route
  get '/show', to: "users#show", as: 'show'


  # Media routes
  get "media/search", to: "media#search", as: 'media_search'
  resources :media, only: [:index, :new, :show]
  get '/media/new/:id', to: 'media#create', as: :new_media

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  get "media/search", to: "media#search"
  get "actor/show", to: "actor#show", as: :actor_show
  # Defines the root path route ("/")
  # root "posts#index"
  resources :watchlist_media, only: [:index, :show, :create, :destroy]

  # User provider routes
  resources :user_providers, only: [:index, :create, :destroy]
  get "user_providers/select", to: "user_providers#select"

  # Game routes
  get "game", to: "games#index", as: :game
  post "game/like", to: "games#like", as: :game_like
  post "game/dislike", to: "games#dislike", as: :game_dislike
  post "game/skip", to: "games#skip", as: :game_skip
  resources :seasons, only: [:show]
end
