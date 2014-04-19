Finance::Application.routes.draw do
  devise_for :users

  resources :dashboard, only: :index

  resources :users, only: [:index, :show]

  resources :entry_types, except: :show

  resources :entries, only: [:create, :destroy]

  root to: 'dashboard#index'
end
