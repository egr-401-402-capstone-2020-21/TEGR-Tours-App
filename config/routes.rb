Rails.application.routes.draw do
<<<<<<< HEAD
  resources :users, only: [:new, :create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  get 'welcome', to: 'user_sessions#welcome'
  get 'authorized', to: 'user_sessions#page_requires_login'
=======
  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'
  resources :users
>>>>>>> master
  root 'static#welcome'
  resources :time_blocks
  resources :courses
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
