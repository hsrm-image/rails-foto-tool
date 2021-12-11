Rails.application.routes.draw do
  devise_for :users
  resources :comments
  resources :ratings
  resources :collections
  resources :images
  resources :tags
  resources :users
  get :userpanel, to: 'userpanels#index'
  get 'userpanels/show_images' , to: 'userpanels#show_images'
  get 'userpanels/show_collections' , to: 'userpanels#show_collections'
  resources :userpanels
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "images#index"
end
