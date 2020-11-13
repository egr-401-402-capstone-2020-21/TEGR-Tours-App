Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'welcome', to: 'user_sessions#welcome'
  get 'authorized', to: 'user_sessions#page_requires_login'
  root 'static#welcome'
  resources :time_blocks
  resources :courses
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
