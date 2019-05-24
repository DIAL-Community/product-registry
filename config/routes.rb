Rails.application.routes.draw do
  devise_for :users
  root to: 'organizations#map'
  
  resources :products

  resources :building_blocks
  resources :sustainable_development_goals, only: [:index]

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
  get 'location_duplicates', :to => 'locations#duplicates'
  get 'sector_duplicates', :to => 'sectors#duplicates'
  get 'product_duplicates', :to => 'products#duplicates'
  get 'building_block_duplicates', :to => 'building_blocks#duplicates'
  get 'organization_duplicates', :to => 'organizations#duplicates'

  get 'productmap', :to => 'products#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
