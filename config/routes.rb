Rails.application.routes.draw do
  namespace :coincheck do
    resources :sales_rates
  end
  namespace :coincheck do
    resources :trading_rates
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
