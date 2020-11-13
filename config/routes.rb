Rails.application.routes.draw do
  resources :admins
  root 'static#welcome'
  resources :time_blocks
  resources :courses
  resources :rooms

  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new'
  get 'login', to: 'admin_sessions#new' 
  post 'login', to: 'admin_sessions#create'
  get 'logout', to: 'admin_sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
