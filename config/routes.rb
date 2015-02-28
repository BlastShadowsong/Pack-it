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

  get "/upload/grid/*path" => "gridfs#serve"

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

    resources :categories, only: [:index, :show] do
      resources :tags, only: [:index]
    end

    resources :problems do
      resources :solutions, only: [:index]
    end

    resources :solutions

  end
  

end