Finance::Application.routes.draw do
  devise_for :users

  controller :dashboard do
    get 'dashboard' => :index
    get 'chart_data' => :chart_data
  end

  resources :users, only: [:index, :show]

  resources :entry_types, except: :show

  resources :entries, only: [:create, :destroy]

  root to: 'dashboard#index'
end
