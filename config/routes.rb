Rails.application.routes.draw do
  namespace :coincheck do
    get 'sales_rates', to: 'sales_rates#index', constraints: {format: 'json'}
  end
  namespace :coincheck do
    get 'trading_rates', to: 'trading_rates#index', constraints: {format: 'json'}
  end

  post 'apps', to: 'apps#create', constraints: {format: 'json'}
  post 'json_web_tokens/verify', to: 'json_web_tokens#verify', constraints: {format: 'json'}
  post 'notification_tokens', to: 'notification_tokens#create', constraints: {format: 'json'}

  # Matches /
  match '(*not_found)' => proc {
    [404, {'Content-Type' => 'text/plain'}, ['404']]
  }, via: :all
end
