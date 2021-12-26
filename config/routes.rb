Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations], controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  
  resources :ratings
  resources :collections
  resources :images do
    patch :analyse, on: :member
    resources :comments
  end
  resources :tags
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "images#index"
end
