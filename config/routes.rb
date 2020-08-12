Rails.application.routes.draw do
  resources :task_trackers
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Commontator::Engine => '/commontator'

  resources :product_suites
  resources :glossaries
  resources :settings

  resources :rubric_categories, only: [:index, :update, :create, :destroy]
  resources :category_indicators, only: [:index, :update, :create, :destroy]
  resources :maturity_rubrics do
    resources :rubric_categories do
      resources :category_indicators
    end
  end

  resources :tasks, only: [:index, :update, :create, :destroy]
  resources :activities, only: [:index, :update, :create, :destroy]
  resources :plays do
    get 'count', on: :collection
    resources :tasks
  end
  resources :playbooks do
    get 'count', on: :collection
    member do 
      get 'create_pdf'
      get 'show_pdf'
    end
    resources :activities do
      resources :tasks
    end
  end

  resources :tags
  resources :use_case_steps

  resources :projects do
    get 'count', on: :collection
    member do
      post 'favorite_project'
      post 'unfavorite_project'
    end
  end

  get 'deploys/index'
  get 'about/cookies'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  scope '/admin' do
    resources :users
  end

  root to: 'about#index'

  resources :covid, only: [:index]

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
    member do
      post 'favorite_product'
      post 'unfavorite_product'
    end
  end

  resources :building_blocks do
    get 'count', on: :collection
  end

  resources :sustainable_development_goals, only: [:index, :show] do
    get 'count', on: :collection
  end

  resources :sdg_targets, only: [:index, :show]

  resources :use_case_steps, only: [:new, :create, :edit, :update, :show]
  resources :use_cases do
    get 'count', on: :collection
    resources :use_case_steps, only: [:new, :create, :edit, :update, :show]
    member do
      post 'favorite_use_case'
      post 'unfavorite_use_case'
    end
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

  resources :cities, only: [:index, :show]
  resources :countries, only: [:index, :show]

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

  resources :tags
  resources :use_case_steps

  get '/object_counts', to: 'application#object_counts', as: :object_counts
  post '/add_filter', to: 'application#add_filter', as: :add_filter
  post '/remove_filter', to: 'application#remove_filter', as: :remove_filter
  post '/remove_all_filters', to: 'application#remove_all_filters', as: :remove_all_filters
  get '/get_filters', to: 'application#get_filters', as: :get_filters
  get '/agg_capabilities', to: 'organizations#agg_capabilities', as: :agg_capabilities
  get '/agg_services', to: 'organizations#agg_services', as: :agg_services
  get '/service_capabilities', to: 'organizations#service_capabilities', as: :service_capabilities
  get '/update_capability', to: 'organizations#update_capability', as: :update_capability
  get '/privacy', to: 'about#privacy', as: :privacy
  get '/terms', to: 'about#terms', as: :terms

  post '/save_url', to: 'application#save_url', as: :save_url

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
  get 'use_case_step_duplicates', to: 'use_case_steps#duplicates'
  get 'tag_duplicates', to: 'tags#duplicates'
  get 'category_indicator_duplicates', to: 'category_indicators#duplicates'
  get 'playbook_duplicates', to: 'playbooks#duplicates'
  get 'play_duplicates', to: 'plays#duplicates'
  get 'task_duplicates', to: 'tasks#duplicates'

  get 'covidresources', :to => 'covid#resources'
  get 'productlist', :to => 'products#productlist', as: :productlist
  get 'productmap', :to => 'products#map'

  get 'map_projects', to: 'projects#map_projects'
  get 'map_covid', to: 'projects#map_covid'

  get 'map_osm', to: 'organizations#map_osm'
  get 'map_aggregators_osm', to: 'organizations#map_aggregators_osm'
  get 'map_projects_osm', to: 'projects#map_projects_osm'
end
