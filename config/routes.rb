Finance::Application.routes.draw do
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :dashboard do
    get 'dashboard' => :index
    get 'chart_data' => :chart_data
  end

  resources :users

  resources :entry_types, except: :show

  resources :entries, only: [:create, :destroy], defaults: { format: :json } do
    collection do
      get :incomes
      get :expenses
    end
  end

  match 'signup', to: 'users#new', via: :get
  root to: 'dashboard#index'
end
