Rails.application.routes.draw do
  devise_for :users
  resources :ratings
  resources :collections
  resources :images do
    resources :comments
  end
  resources :tags
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "images#index"
end
