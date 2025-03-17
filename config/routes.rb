Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Notification routes
  namespace :api do
    resources :notifications, only: [ :index, :show, :create ] do
      member do
        get :status # GET /api/notifications/:id/status
      end
    end

    # User preferences routes
    resources :users, only: [] do
      resource :preferences, controller: "user_preferences", only: [ :show, :update ]
    end
  end
end
