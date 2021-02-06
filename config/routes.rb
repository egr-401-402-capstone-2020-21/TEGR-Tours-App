Rails.application.routes.draw do
  devise_for :users
  root 'static#welcome'
  resources :time_blocks
  resources :courses
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
