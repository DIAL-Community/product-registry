Rails.application.routes.draw do
  devise_for :users
  root to: 'organizations#map'
  resources :products

  resources :organizations do
    resources :contacts
    resources :locations
    resources :sectors
  end

  resources :locations do
    resources :organizations
  end

  resources :sectors do
    resources :organizations
  end

  resources :contacts do
    resources :organizations
  end

  get 'map', :to => 'organizations#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
