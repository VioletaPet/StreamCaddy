Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :media, only: [:index, :new, :show]
    get '/media/new/:id', to: 'media#create', as: :new_media
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "media/search", to: "media#search"

  # Defines the root path route ("/")
  # root "posts#index"
  resources :user_providers, only: [:index, :new, :create]
  get "user_providers/select", to: "user_providers#select"
end
