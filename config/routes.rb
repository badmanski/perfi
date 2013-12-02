Finance::Application.routes.draw do
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :entry_types, except: :show

  get 'dashboard', to: 'dashboard#index'
  match 'signup', to: 'users#new', via: :get
  root to: 'dashboard#index'
end
