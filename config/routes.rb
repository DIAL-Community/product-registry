Rails.application.routes.draw do

  resources :projects, only: [:index, :show, :destroy]

  get 'deploys/index'

  devise_for :users
  scope '/admin' do
    resources :users
  end

  root to: 'organizations#map'

  resources :products

  resources :building_blocks do
    post 'add_filter', on: :collection
    post 'remove_filter', on: :collection
    get 'count', on: :collection
    get 'view', on: :collection
  end

  resources :sustainable_development_goals, only: [:index, :show]
  resources :sdg_targets, only: [:index, :show]

  resources :use_cases do
    resources :sdg_targets
    resources :workflows
  end

  resources :workflows do
    resources :use_cases
  end

  resources :deploys do
    get 'show_messages'
    post 'add_ssh_user'
  end

  resources :organizations do
    post 'add_filter', on: :collection
    post 'remove_filter', on: :collection
    get 'all_filters', on: :collection
    get 'count', on: :collection
    get 'view', on: :collection
  end

  resources :locations do
    resources :organizations
  end

  resources :sectors do
    resources :organizations
    resources :use_cases
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
  get 'use_case_duplicates', :to => 'use_cases#duplicates'
  get 'workflow_duplicates', :to => 'workflows#duplicates'
  get 'deploys_refresh_list', :to => 'deploys#refresh_list'

  get 'productmap', :to => 'products#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
