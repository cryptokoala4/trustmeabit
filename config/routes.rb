Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root 'pages#index'

  resources :wallets, except: [:destroy]
  # get 'api/index' => 'wallets#index'

  # get 'api/show' => 'wallets#show'

  # get 'api/create' => 'wallets#create'

  # get 'api/post' => 'wallets#post'

end
