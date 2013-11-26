Finance::Application.routes.draw do
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users

  get 'dashboard', to: 'dashboard#index'
  root to: 'dashboard#index'
end
