Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations], controllers: {
    invitations: 'users/invitations'
  }
  as :user do
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
    delete 'users' => 'users/registrations#destroy', :as => 'delete_user_registration'
  end

  resources :ratings
  resources :collections
  resources :images do
    patch :analyse, on: :member
    resources :comments
  end
  resources :tags
  resources :users, only: [:index, :show, :destroy] do
    patch :admin, on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "images#index"
end
