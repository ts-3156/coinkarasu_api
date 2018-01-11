Rails.application.routes.draw do
  namespace :coincheck do
    # resources :sales_rates
    get 'sales_rates', to: 'sales_rates#index'
  end
  namespace :coincheck do
    # resources :trading_rates
    get 'trading_rates', to: 'trading_rates#index'
  end
end
