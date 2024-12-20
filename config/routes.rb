Rails.application.routes.draw do
  devise_for :users
  root to: "media#index"

  # User show route
  get '/show', to: "users#show", as: 'show'

  get '/media/filter', to: 'media#filter'
  # Media routes
  get "media/search", to: "media#search", as: 'media_search'

  resources :media, only: [:index, :new, :show] do
    resources :reviews, only: [:new, :create, :show, :index]
  end

  get '/media/new/:id', to: 'media#create', as: :new_media
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "media/search", to: "media#search"
  get "actor/show", to: "actor#show", as: :actor_show
  # Defines the root path route ("/")
  # root "posts#index"
  resources :watchlist_media, only: [:index, :show, :create, :destroy] do
    collection do
      get :schedule
      get :schedule_month
    end
  end

  # User provider routes
  resources :user_providers, only: [:index, :create, :destroy, :update] do
    collection do
      get :edit
      patch :update
    end
  end

  # Game routes
  get "game", to: "games#index", as: :game
  post "game/like", to: "games#like", as: :game_like
  post "game/dislike", to: "games#dislike", as: :game_dislike
  post "game/skip", to: "games#skip", as: :game_skip
  resources :seasons, only: [:show]
  end
