Finance::Application.routes.draw do
  resources :users

  get 'dashboard', to: 'dashboard#index'
  root to: 'dashboard#index'
end
