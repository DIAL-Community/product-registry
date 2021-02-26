Rails.application.routes.draw do
  if Rails.env.development?
    mount(GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql")
  end

  post "/graphql", to: "graphql#execute"

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Commontator::Engine => '/commontator'

  resources :task_trackers

  resources :candidate_products do
    member do
      post 'reject'
      post 'approve'
    end
  end

  resources :candidate_roles do
    member do
      post 'reject'
      post 'approve'
    end
  end

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

  resources :playbook_pages, only: [:index, :update, :create, :destroy]
  resources :playbooks do
    get 'count', on: :collection
    post 'upload_design_images', on: :collection
    member do
      post 'convert_pages'
    end
    resources :playbook_pages do
      member do
        get 'copy_page'
        get 'edit_content'
        get 'load_design'
        post 'save_design'
        patch 'save_design'
        get 'create_pdf'
        get 'show_pdf'
      end
    end
  end

  resources :tags
  resources :use_case_steps

  resources :projects do
    get 'count', on: :collection
    get 'export_data', on: :collection
    member do
      post 'favorite_project'
      post 'unfavorite_project'
    end
  end

  get 'deploys/index'
  get 'about/cookies'
  get 'about', to: 'about#index'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  scope '/admin' do
    resources :users do
      get 'statistics', on: :collection
    end
  end

  devise_scope :user do
    get '/users', to: 'registrations#new'
    get '/users/password', to: 'devise/passwords#new'
  end

  root to: redirect(path: '/products')

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
    get 'export_data', on: :collection
    member do
      post 'favorite_product'
      post 'unfavorite_product'
    end
  end

  resources :building_blocks do
    get 'count', on: :collection
    get 'export_data', on: :collection
  end

  resources :sustainable_development_goals, only: [:index, :show] do
    get 'count', on: :collection
  end

  resources :sdg_targets, only: [:index, :show]

  resources :use_case_steps, only: [:new, :create, :edit, :update, :show]
  resources :use_cases do
    get 'count', on: :collection
    get 'export_data', on: :collection
    resources :use_case_steps, only: [:new, :create, :edit, :update, :show]
    member do
      post 'favorite_use_case'
      post 'unfavorite_use_case'
    end
  end

  resources :workflows do
    get 'count', on: :collection
    get 'export_data', on: :collection
  end

  resources :deploys do
    get 'show_messages'
    post 'add_ssh_user'
  end

  resources :organizations do
    get 'count', on: :collection
    get 'export_data', on: :collection
  end

  get :update_locale, controller:"application"

  # Start of external API routes
  get 'api/v1/organizations/:id', to: 'organizations#unique_search'
  get 'api/v1/organizations', to: 'organizations#simple_search'
  post 'api/v1/organizations', to: 'organizations#complex_search'

  get 'api/v1/building_blocks/:id', to: 'building_blocks#unique_search'
  get 'api/v1/building_blocks', to: 'building_blocks#simple_search'
  post 'api/v1/building_blocks', to: 'building_blocks#complex_search'

  get 'api/v1/cities/:id', to: 'cities#unique_search'
  get 'api/v1/cities', to: 'cities#simple_search'

  get 'api/v1/countries/:id', to: 'countries#unique_search'
  get 'api/v1/countries', to: 'countries#simple_search'

  get 'api/v1/products/:id', to: 'products#unique_search'
  get 'api/v1/products', to: 'products#simple_search'
  post 'api/v1/products', to: 'products#complex_search'

  get 'api/v1/projects/:id', to: 'projects#unique_search'
  get 'api/v1/projects', to: 'projects#simple_search'
  post 'api/v1/projects', to: 'projects#complex_search'

  get 'api/v1/sectors/:id', to: 'sectors#unique_search'
  get 'api/v1/sectors', to: 'sectors#simple_search'

  get 'api/v1/sdgs/:id', to: 'sustainable_development_goals#unique_search'
  get 'api/v1/sdgs', to: 'sustainable_development_goals#simple_search'

  get 'api/v1/sustainable_development_goals/:id', to: 'sustainable_development_goals#unique_search'
  get 'api/v1/sustainable_development_goals', to: 'sustainable_development_goals#simple_search'

  get 'api/v1/tags/:id', to: 'tags#unique_search'
  get 'api/v1/tags', to: 'tags#simple_search'

  get 'api/v1/use_cases/:id', to: 'use_cases#unique_search'
  get 'api/v1/use_cases', to: 'use_cases#simple_search'
  post 'api/v1/use_cases', to: 'use_cases#complex_search'

  get 'api/v1/use_cases/:id/use_case_steps/:step_id', to: 'use_case_steps#unique_search'
  get 'api/v1/use_cases/:id/use_case_steps', to: 'use_case_steps#simple_search'

  get 'api/v1/workflows/:id', to: 'workflows#unique_search'
  get 'api/v1/workflows', to: 'workflows#simple_search'
  post 'api/v1/workflows', to: 'workflows#complex_search'

  # End of external API routes

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
  post '/add_filters', to: 'application#add_filters', as: :add_filters
  post '/remove_filter', to: 'application#remove_filter', as: :remove_filter
  post '/remove_all_filters', to: 'application#remove_all_filters', as: :remove_all_filters
  get '/get_filters', to: 'application#get_filters', as: :get_filters
  get '/agg_capabilities', to: 'organizations#agg_capabilities', as: :agg_capabilities
  get '/agg_services', to: 'organizations#agg_services', as: :agg_services
  get '/service_capabilities', to: 'organizations#service_capabilities', as: :service_capabilities
  get '/update_capability', to: 'organizations#update_capability', as: :update_capability
  get '/privacy', to: 'about#privacy', as: :privacy
  get '/terms', to: 'about#terms', as: :terms
  get '/healthcheck', to: 'about#healthcheck', as: :healthcheck

  post '/save_url', to: 'application#save_url', as: :save_url
  post '/remove_url', to: 'application#remove_url', as: :remove_url

  get 'export', :to => 'organizations#export'
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
  get 'playbook_page_duplicates', to: 'playbook_pages#duplicates'
  get 'candidate_product_duplicates', to: 'candidate_products#duplicates'

  post '/froala_image/upload' => 'froala_images#upload'

  get 'covidresources', :to => 'covid#resources'
  get 'productlist', :to => 'products#productlist', as: :productlist
  get 'productmap', :to => 'products#map'

  get 'map_projects', to: 'projects#map_projects'
  get 'map_covid', to: 'projects#map_covid'

  get 'map', to: 'organizations#map'
  get 'map_osm', to: 'organizations#map_osm'
  get 'map_fs', :to => 'organizations#map_fs'
  get 'map_aggregators_osm', to: 'organizations#map_aggregators_osm'
  get 'map_projects_osm', to: 'projects#map_projects_osm'
end
