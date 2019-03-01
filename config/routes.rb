Rails.application.routes.draw do
  devise_for :users
  root to: 'organizations#map'
  resources :sectors
  resources :locations
  resources :contacts
  resources :products
  resources :organizations
  get 'map', :to => 'organizations#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
