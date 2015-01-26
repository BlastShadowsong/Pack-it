Rails.application.routes.draw do

  use_doorkeeper
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticate :user, lambda { |u| u.role.admin? } do
    mount Sidekiq::Web => '/jobs', as: 'sidekiq'
  end

  RailsAdmin.config.navigation_static_links = {
    'Background Jobs' => Rails.application.routes.url_helpers.sidekiq_path,
    'OAuth Applications' => Rails.application.routes.url_helpers.oauth_applications_path,
    'OAuth Authorized Applications' => Rails.application.routes.url_helpers.oauth_authorized_applications_path

  }

  root 'home#index'

  api_version(:module => "Api::V1", :header => {:name => "API-VERSION", :value => "v1"}) do

    resource :me, controller: :users, except: [:new, :edit]

    resources :profiles, param: :type, only: [:index, :show, :update] do
      post ':field', to: 'profiles#add'
      delete ':field', to: 'profiles#remove'
    end

    resources :users, only: [:index, :show] do
      resources :profiles, param: :type, only: [:index, :show]
    end

    resources :cities, only: [:index, :show] do
      resources :malls, only: [:index]
      resources :shops, only: [:index]
      resources :bargains, only: [:index]
    end

    resources :malls, only: [:show] do
      resources :beacons, only: [:index]
      resources :passages, only: [:index]
      resources :facilities, only: [:index]
      resources :shops, only: [:index]
      resources :bargains, only: [:index]
    end

    resources :shops, only: [:show] do
      resources :bargains, only: [:index]
    end

    resources :bargains, only: [:show]

    resources :categories, only: [:index, :show] do
      resources :tags, only: [:index]
    end

    resources :tags, only: [:index, :show] do
      resources :shops, only: [:index]
      resources :bargains, only: [:index]
    end

    resources :problems do
      resources :solutions, shallow: true
    end

    resources :notification_messages, only: [:index, :destroy]
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end