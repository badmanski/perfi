Finance::Application.routes.draw do
  devise_for :users, path: ''

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

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
