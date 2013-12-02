Finance::Application.routes.draw do
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :entry_types, except: :show
  resources :entries,
            only: [:index, :create, :destroy],
            defaults: { format: :json }

  get 'dashboard', to: 'dashboard#index'
  match 'signup', to: 'users#new', via: :get
  root to: 'dashboard#index'
end
