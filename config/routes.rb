Rails.application.routes.draw do
  devise_for :users
  root to: 'organizations#map'
  resources :products
  resources :building_blocks

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

  get 'export', :to => 'organizations#export'
  get 'map', :to => 'organizations#map'

  get 'contact_duplicates', :to => 'contacts#duplicates'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
