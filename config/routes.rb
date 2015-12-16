Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root 'pages#index'

  post '/wallets/send_money', to: "wallets#send_money"
  resources :wallets, except: [:destroy]

  get '/users/:identification', to: "users#identification"
  # get 'api/index' => 'wallets#index'

  # get 'api/show' => 'wallets#show'

  # get 'api/create' => 'wallets#create'

  # get 'api/post' => 'wallets#post'

 # resources :users, only: [:update, :create]

end
