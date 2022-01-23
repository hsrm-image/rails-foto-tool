Rails.application.routes.draw do
	scope '(:locale)' do
		devise_for :users,
		           skip: [:registrations],
		           controllers: {
				invitations: 'users/invitations',
		           }
		as :user do
			get 'users/edit' => 'users/registrations#edit',
			    :as => 'edit_user_registration'
			put 'users' => 'users/registrations#update',
			    :as => 'user_registration'
			delete 'users' => 'users/registrations#destroy',
			       :as => 'delete_user_registration'
		end

		resources :ratings, only: %i[create destroy]
		resources :collections
		resources :images do
			patch :analyse, on: :member
			resources :comments
		end
		resources :users, only: %i[index show destroy] do
			patch :admin, on: :member
		end

	get :userpanel, to: 'userpanels#index'
	get 'userpanel/show_images', to: 'userpanels#show_images'
	get 'userpanel/show_collections', to: 'userpanels#show_collections'
	get 'userpanel/show_details', to: 'userpanels#show_details'
	get 'userpanel/create_collection', to: 'userpanels#create_collection'
	get 'userpanel/show_collection_details',
	    to: 'userpanels#show_collection_details'
	post 'userpanel/join_collection_image',
	     to: 'userpanels#add_image_to_collection'
	post 'userpanel/part_collection_image',
	     to: 'userpanels#remove_image_from_collection'
	post 'userpanel/set_collection_header',
	     to: 'userpanels#set_collection_header'
	post 'userpanel/startProccess', to: 'userpanels#startProccess'

		# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
		root to: 'images#index'
	end

end
