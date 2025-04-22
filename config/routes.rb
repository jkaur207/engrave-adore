Rails.application.routes.draw do
  post '/stripe/webhook', to: 'webhooks#stripe'

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: { registrations: 'users/registrations' }

  ActiveAdmin.routes(self)

  resources :pages, only: [:show], param: :title

  root "home#index"
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resource :cart, only: [:show] do
    post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: :add_to_cart
    delete 'remove/:product_id', to: 'carts#remove_from_cart', as: :remove_from_cart
    patch 'update/:product_id', to: 'carts#update_quantity', as: :update_cart
    delete 'clear', to: 'carts#clear_cart', as: :clear_cart
  end

  # Updated checkout routes with payment endpoints
  resource :checkout, only: [:new, :create, :show] do
    collection do
      get :confirmation
      post :create_checkout_session  # ✅ now correctly scoped
    end
  end

  resources :products do
    collection { get :search }
    member { delete :remove_image }
  end

  resources :orders, only: [:show]
end
