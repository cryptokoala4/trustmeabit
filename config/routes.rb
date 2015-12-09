Rails.application.routes.draw do
  get 'wallets/index'

  get 'wallets/show'

  root :to => 'pages#index'

end
