Rails.application.routes.draw do
  resources :products do
    collection do
      get 'cart_items', action: 'cart_items', as: 'cart_items'
      get 'add_to_cart', action: 'add_to_cart', as: 'add_to_cart'
    end
  end
  devise_for :users
  root 'pages#dashboard'
  get 'pages/settings'
  get 'stripe/connect'
  get 'checkout/thankyou'
  post 'checkout', to: 'checkout#create'
end
