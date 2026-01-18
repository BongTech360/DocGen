Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path
  root "home#index"

  # Organizations routes (admin only)
  resources :organizations, except: [:destroy] do
    member do
      get :users
    end
  end

  # Documents routes
  resources :documents do
    member do
      get :generate_pdf
      get :verify
      post :verify
    end
    collection do
      get :by_type
    end
  end

  # API routes (optional, for future API access)
  namespace :api do
    namespace :v1 do
      resources :documents, only: [:index, :show, :create, :update] do
        member do
          get :generate_pdf
          get :verify
        end
      end
    end
  end
end
