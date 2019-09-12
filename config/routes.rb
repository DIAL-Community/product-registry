Rails.application.routes.draw do
  resources :projects, only: [:index, :show, :destroy]

  get 'deploys/index'
  get 'about/cookies'

  devise_for :users, controllers: { registrations: 'registrations' }
  scope '/admin' do
    resources :users
  end

  root to: 'about#index'

  resources :products do
    get 'count', on: :collection
  end

  resources :building_blocks do
    get 'count', on: :collection
  end

  resources :sustainable_development_goals, only: [:index, :show] do
    get 'count', on: :collection
  end

  resources :sdg_targets, only: [:index, :show]

  resources :use_cases do
    get 'count', on: :collection
  end

  resources :workflows do
    get 'count', on: :collection
  end

  resources :deploys do
    get 'show_messages'
    post 'add_ssh_user'
  end

  resources :organizations do
    get 'count', on: :collection
  end

  resources :audits, only: [:index]

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

  post '/add_filter', to: 'application#add_filter', as: :add_filter
  post '/remove_filter', to: 'application#remove_filter', as: :remove_filter
  get '/get_filters', to: 'application#get_filters', as: :get_filters

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
