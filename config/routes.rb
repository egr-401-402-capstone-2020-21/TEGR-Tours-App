Rails.application.routes.draw do
  resources :artifacts
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :displays
  root 'static#welcome'
  resources :time_blocks
  resources :courses
  resources :rooms
  get '/map', to: 'static#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
