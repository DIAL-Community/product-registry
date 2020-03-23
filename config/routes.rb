Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :product_suites
  resources :glossaries
  resources :settings

  resources :projects do
    get 'count', on: :collection
  end

  get 'deploys/index'
  get 'about/cookies'

  devise_for :users, controllers: { registrations: 'registrations' }
  scope '/admin' do
    resources :users
  end

  root to: 'about#index'

  resources :candidate_organizations do
    member do
      post 'reject'
      post 'approve'
    end
  end

  resources :portal_views do
    member do
      post 'select'
    end
  end

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

  resources :operator_services

  resources :audits, only: [:index]

  resources :stylesheets

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
  post '/remove_all_filters', to: 'application#remove_all_filters', as: :remove_all_filters
  get '/get_filters', to: 'application#get_filters', as: :get_filters
  get '/agg_capabilities', to: 'organizations#agg_capabilities', as: :agg_capabilities
  get '/agg_services', to: 'organizations#agg_services', as: :agg_services
  get '/service_capabilities', to: 'organizations#service_capabilities', as: :service_capabilities
  get '/update_capability', to: 'organizations#update_capability', as: :update_capability

  get 'export', :to => 'organizations#export'
  get 'map_aggregators', :to => 'organizations#map_aggregators'
  get 'map', :to => 'organizations#map'
  get 'map_fs', :to => 'organizations#map_fs'
  get 'candidate_organization_duplicates', :to => 'candidate_organizations#duplicates'
  get 'contact_duplicates', :to => 'contacts#duplicates'
  get 'location_duplicates', :to => 'locations#duplicates'
  get 'sector_duplicates', :to => 'sectors#duplicates'
  get 'product_duplicates', :to => 'products#duplicates'
  get 'building_block_duplicates', :to => 'building_blocks#duplicates'
  get 'organization_duplicates', :to => 'organizations#duplicates'
  get 'use_case_duplicates', :to => 'use_cases#duplicates'
  get 'workflow_duplicates', :to => 'workflows#duplicates'
  get 'glossary_duplicates', :to => 'glossaries#duplicates'
  get 'product_suite_duplicates', :to => 'product_suites#duplicates'
  get 'deploys_refresh_list', :to => 'deploys#refresh_list'
  get 'project_duplicates', to: 'projects#duplicates'
  get 'portal_view_duplicates', to: 'portal_views#duplicates'

  get 'productlist', :to => 'products#productlist', as: :productlist
  get 'productmap', :to => 'products#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'map_projects', to: 'projects#map_projects'
end
