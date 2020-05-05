# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_03_141314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "aggregator_capabilities" because of following StandardError
#   Unknown type 'mobile_services' for column 'service'

  create_table "audits", force: :cascade do |t|
    t.integer "audit_id"
    t.string "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_role"
    t.string "username"
    t.string "action"
    t.jsonb "audit_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.datetime "created_at"
    t.index ["action", "audit_id", "version"], name: "auditable_index"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["user_id", "user_role"], name: "user_index"
  end

  create_table "building_block_descriptions", force: :cascade do |t|
    t.bigint "building_block_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["building_block_id"], name: "index_building_block_descriptions_on_building_block_id"
  end

  create_table "building_blocks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["slug"], name: "index_building_blocks_on_slug", unique: true
  end

  create_table "candidate_organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "website"
    t.boolean "rejected"
    t.datetime "rejected_date"
    t.bigint "rejected_by_id"
    t.datetime "approved_date"
    t.bigint "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_candidate_organizations_on_approved_by_id"
    t.index ["rejected_by_id"], name: "index_candidate_organizations_on_rejected_by_id"
  end

  create_table "candidate_organizations_contacts", id: false, force: :cascade do |t|
    t.bigint "candidate_organization_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.index ["candidate_organization_id", "contact_id"], name: "index_candidate_contacts_on_candidate_id_and_contact_id"
    t.index ["contact_id", "candidate_organization_id"], name: "index_candidate_contacts_on_contact_id_and_candidate_id"
  end

  create_table "classifications", force: :cascade do |t|
    t.string "name"
    t.string "indicator"
    t.string "description"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.string "email"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_contacts_on_slug", unique: true
  end

  create_table "deploys", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.string "provider"
    t.string "instance_name"
    t.string "auth_token"
    t.string "status"
    t.string "message"
    t.string "url"
    t.string "suite"
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_deploys_on_product_id"
    t.index ["user_id"], name: "index_deploys_on_user_id"
  end

  create_table "glossaries", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "locations" because of following StandardError
#   Unknown type 'location_type' for column 'location_type'

# Could not dump table "operator_services" because of following StandardError
#   Unknown type 'mobile_services' for column 'service'

  create_table "organization_descriptions", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_descriptions_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.datetime "when_endorsed"
    t.string "website"
    t.boolean "is_endorser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_mni", default: false
    t.string "aliases", default: [], array: true
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "organizations_contacts", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
  end

  create_table "organizations_locations", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "organization_id", null: false
    t.index ["location_id", "organization_id"], name: "loc_orcs", unique: true
    t.index ["organization_id", "location_id"], name: "org_locs", unique: true
  end

# Could not dump table "organizations_products" because of following StandardError
#   Unknown type 'org_type_orig' for column 'org_type'

  create_table "organizations_sectors", id: false, force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id", "sector_id"], name: "org_sectors", unique: true
    t.index ["sector_id", "organization_id"], name: "sector_orcs", unique: true
  end

  create_table "origins", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "name"
    t.string "slug"
    t.string "description"
    t.datetime "last_synced"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_origins_on_organization_id"
  end

  create_table "portal_views", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.string "description"
    t.string "top_navs", default: [], array: true
    t.string "filter_navs", default: [], array: true
    t.string "user_roles", default: [], array: true
    t.string "product_views", default: [], array: true
    t.string "organization_views", default: [], array: true
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "product_assessments" because of following StandardError
#   Unknown type 'digisquare_maturity_level' for column 'digisquare_country_utilization'

  create_table "product_classifications", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "classification_id"
    t.index ["classification_id", "product_id"], name: "classifications_products_idx", unique: true
    t.index ["classification_id"], name: "index_product_classifications_on_classification_id"
    t.index ["product_id", "classification_id"], name: "products_classifications_idx", unique: true
    t.index ["product_id"], name: "index_product_classifications_on_product_id"
  end

  create_table "product_descriptions", force: :cascade do |t|
    t.bigint "product_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_descriptions_on_product_id"
  end

# Could not dump table "product_product_relationships" because of following StandardError
#   Unknown type 'relationship_type' for column 'relationship_type'

  create_table "product_suites", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_suites_product_versions", id: false, force: :cascade do |t|
    t.bigint "product_suite_id", null: false
    t.bigint "product_version_id", null: false
    t.index ["product_suite_id", "product_version_id"], name: "product_suites_products_versions"
    t.index ["product_version_id", "product_suite_id"], name: "products_versions_product_suites"
  end

  create_table "product_versions", force: :cascade do |t|
    t.bigint "product_id"
    t.string "version", null: false
    t.integer "version_order", null: false
    t.index ["product_id"], name: "index_product_versions_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_launchable", default: false
    t.boolean "start_assessment"
    t.string "default_url", default: "http://<host_ip>", null: false
    t.string "aliases", default: [], array: true
    t.string "repository"
    t.string "license"
    t.string "license_analysis"
    t.jsonb "statistics", default: "{}", null: false
    t.boolean "is_child", default: false
    t.integer "parent_product_id"
    t.string "tags", default: [], array: true
    t.integer "code_lines"
    t.integer "cocomo"
    t.integer "est_hosting"
    t.integer "est_invested"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "products_building_blocks", id: false, force: :cascade do |t|
    t.bigint "building_block_id", null: false
    t.bigint "product_id", null: false
    t.index ["building_block_id", "product_id"], name: "block_prods", unique: true
    t.index ["product_id", "building_block_id"], name: "prod_blocks", unique: true
  end

  create_table "products_origins", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "origin_id", null: false
    t.index ["origin_id", "product_id"], name: "origins_products_idx", unique: true
    t.index ["product_id", "origin_id"], name: "products_origins_idx", unique: true
  end

  create_table "products_sectors", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "sector_id", null: false
    t.index ["product_id", "sector_id"], name: "index_products_sectors_on_product_id_and_sector_id"
    t.index ["sector_id", "product_id"], name: "index_products_sectors_on_sector_id_and_product_id"
  end

  create_table "products_sustainable_development_goals", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "sustainable_development_goal_id", null: false
    t.string "link_type"
    t.index ["product_id", "sustainable_development_goal_id"], name: "prod_sdgs", unique: true
    t.index ["sustainable_development_goal_id", "product_id"], name: "sdgs_prods", unique: true
  end

  create_table "project_descriptions", force: :cascade do |t|
    t.bigint "project_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_descriptions_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "origin_id"
    t.date "start_date"
    t.date "end_date"
    t.decimal "budget", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.index ["origin_id"], name: "index_projects_on_origin_id"
  end

  create_table "projects_locations", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "location_id", null: false
    t.index ["location_id", "project_id"], name: "locations_projects_idx", unique: true
    t.index ["project_id", "location_id"], name: "projects_locations_idx", unique: true
  end

  create_table "projects_organizations", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id", "project_id"], name: "organizations_projects_idx", unique: true
    t.index ["project_id", "organization_id"], name: "projects_organizations_idx", unique: true
  end

  create_table "projects_products", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id", "project_id"], name: "products_projects_idx", unique: true
    t.index ["project_id", "product_id"], name: "projects_products_idx", unique: true
  end

  create_table "projects_sdgs", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "sdg_id", null: false
    t.index ["project_id", "sdg_id"], name: "projects_sdgs_idx", unique: true
    t.index ["sdg_id", "project_id"], name: "sdgs_projects_idx", unique: true
  end

  create_table "projects_sectors", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "sector_id", null: false
    t.index ["project_id", "sector_id"], name: "projects_sectors_idx", unique: true
    t.index ["sector_id", "project_id"], name: "sectors_projects_idx", unique: true
  end

  create_table "sdg_targets", force: :cascade do |t|
    t.string "name"
    t.string "target_number"
    t.string "slug"
    t.integer "sdg_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_displayable"
    t.index ["slug"], name: "index_sectors_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stylesheets", force: :cascade do |t|
    t.string "portal"
    t.string "background_color"
    t.jsonb "about_page", default: "{}", null: false
    t.jsonb "footer_content", default: "{}", null: false
    t.string "header_logo"
  end

  create_table "sustainable_development_goals", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "long_title"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_sdgs_on_slug", unique: true
  end

  create_table "tag_descriptions", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["tag_id"], name: "index_tag_descriptions_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "use_case_descriptions", force: :cascade do |t|
    t.bigint "use_case_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["use_case_id"], name: "index_use_case_descriptions_on_use_case_id"
  end

  create_table "use_case_headers", force: :cascade do |t|
    t.bigint "use_case_id"
    t.string "locale", null: false
    t.jsonb "header", default: {}, null: false
    t.index ["use_case_id"], name: "index_use_case_headers_on_use_case_id"
  end

  create_table "use_case_step_descriptions", force: :cascade do |t|
    t.bigint "use_case_step_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["use_case_step_id"], name: "index_use_case_step_descriptions_on_use_case_step_id"
  end

  create_table "use_case_steps", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "step_number", null: false
    t.bigint "use_case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["use_case_id"], name: "index_use_case_steps_on_use_case_id"
  end

  create_table "use_case_steps_products", force: :cascade do |t|
    t.bigint "use_case_step_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id", "use_case_step_id"], name: "products_use_case_steps_idx", unique: true
    t.index ["use_case_step_id", "product_id"], name: "use_case_steps_products_idx", unique: true
  end

  create_table "use_case_steps_workflows", id: false, force: :cascade do |t|
    t.bigint "use_case_step_id", null: false
    t.bigint "workflow_id", null: false
    t.index ["use_case_step_id", "workflow_id"], name: "use_case_steps_workflows_idx", unique: true
    t.index ["workflow_id", "use_case_step_id"], name: "workflows_use_case_steps_idx", unique: true
  end

  create_table "use_cases", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: "{}", null: false
    t.string "maturity", default: "Beta"
    t.string "tags", default: [], array: true
    t.index ["sector_id"], name: "index_use_cases_on_sector_id"
  end

  create_table "use_cases_sdg_targets", id: false, force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.bigint "sdg_target_id", null: false
    t.index ["sdg_target_id", "use_case_id"], name: "sdgs_usecases", unique: true
    t.index ["use_case_id", "sdg_target_id"], name: "usecases_sdgs", unique: true
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'user_role' for column 'role'

  create_table "users_products", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id", "user_id"], name: "products_users_idx", unique: true
    t.index ["user_id", "product_id"], name: "users_products_idx", unique: true
  end

  create_table "workflow_descriptions", force: :cascade do |t|
    t.bigint "workflow_id"
    t.string "locale", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["workflow_id"], name: "index_workflow_descriptions_on_workflow_id"
  end

  create_table "workflows", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: "{}", null: false
  end

  create_table "workflows_building_blocks", id: false, force: :cascade do |t|
    t.bigint "workflow_id", null: false
    t.bigint "building_block_id", null: false
    t.index ["building_block_id", "workflow_id"], name: "bbs_workflows", unique: true
    t.index ["workflow_id", "building_block_id"], name: "workflows_bbs", unique: true
  end

  create_table "workflows_use_cases", id: false, force: :cascade do |t|
    t.bigint "workflow_id", null: false
    t.bigint "use_case_id", null: false
    t.index ["use_case_id", "workflow_id"], name: "usecases_workflows", unique: true
    t.index ["workflow_id", "use_case_id"], name: "workflows_usecases", unique: true
  end

  add_foreign_key "aggregator_capabilities", "operator_services", column: "operator_services_id"
  add_foreign_key "aggregator_capabilities", "organizations", column: "aggregator_id"
  add_foreign_key "building_block_descriptions", "building_blocks"
  add_foreign_key "candidate_organizations", "users", column: "approved_by_id"
  add_foreign_key "candidate_organizations", "users", column: "rejected_by_id"
  add_foreign_key "deploys", "products"
  add_foreign_key "deploys", "users"
  add_foreign_key "operator_services", "locations", column: "locations_id"
  add_foreign_key "organization_descriptions", "organizations"
  add_foreign_key "organizations_contacts", "contacts", name: "organizations_contacts_contact_fk"
  add_foreign_key "organizations_contacts", "organizations", name: "organizations_contacts_organization_fk"
  add_foreign_key "organizations_locations", "locations", name: "organizations_locations_location_fk"
  add_foreign_key "organizations_locations", "organizations", name: "organizations_locations_organization_fk"
  add_foreign_key "organizations_products", "organizations", name: "organizations_products_organization_fk"
  add_foreign_key "organizations_products", "products", name: "organizations_products_product_fk"
  add_foreign_key "organizations_sectors", "organizations", name: "organizations_sectors_organization_fk"
  add_foreign_key "organizations_sectors", "sectors", name: "organizations_sectors_sector_fk"
  add_foreign_key "product_assessments", "products"
  add_foreign_key "product_classifications", "classifications"
  add_foreign_key "product_classifications", "classifications", name: "product_classifications_classification_fk"
  add_foreign_key "product_classifications", "products"
  add_foreign_key "product_classifications", "products", name: "product_classifications_product_fk"
  add_foreign_key "product_descriptions", "products"
  add_foreign_key "product_product_relationships", "products", column: "from_product_id", name: "from_product_fk"
  add_foreign_key "product_product_relationships", "products", column: "to_product_id", name: "to_product_fk"
  add_foreign_key "product_suites_product_versions", "product_suites", name: "pspv_product_suites_fk"
  add_foreign_key "product_suites_product_versions", "product_versions", name: "pspv_product_versions_fk"
  add_foreign_key "product_versions", "products"
  add_foreign_key "products_building_blocks", "building_blocks", name: "products_building_blocks_building_block_fk"
  add_foreign_key "products_building_blocks", "products", name: "products_building_blocks_product_fk"
  add_foreign_key "products_origins", "origins", name: "products_origins_origin_fk"
  add_foreign_key "products_origins", "products", name: "products_origins_product_fk"
  add_foreign_key "products_sustainable_development_goals", "products", name: "products_sdgs_product_fk"
  add_foreign_key "products_sustainable_development_goals", "sustainable_development_goals", name: "products_sdgs_sdg_fk"
  add_foreign_key "project_descriptions", "projects"
  add_foreign_key "projects", "origins"
  add_foreign_key "projects_locations", "locations", name: "projects_locations_location_fk"
  add_foreign_key "projects_locations", "projects", name: "projects_locations_project_fk"
  add_foreign_key "projects_organizations", "organizations", name: "projects_organizations_organization_fk"
  add_foreign_key "projects_organizations", "projects", name: "projects_organizations_project_fk"
  add_foreign_key "projects_products", "products", name: "projects_products_product_fk"
  add_foreign_key "projects_products", "projects", name: "projects_products_project_fk"
  add_foreign_key "projects_sdgs", "projects", name: "projects_sdgs_project_fk"
  add_foreign_key "projects_sdgs", "sustainable_development_goals", column: "sdg_id", name: "projects_sdgs_sdg_fk"
  add_foreign_key "projects_sectors", "projects", name: "projects_sectors_project_fk"
  add_foreign_key "projects_sectors", "sectors", name: "projects_sectors_sector_fk"
  add_foreign_key "tag_descriptions", "tags"
  add_foreign_key "use_case_descriptions", "use_cases"
  add_foreign_key "use_case_headers", "use_cases"
  add_foreign_key "use_case_step_descriptions", "use_case_steps"
  add_foreign_key "use_case_steps", "use_cases"
  add_foreign_key "use_case_steps_products", "products", name: "use_case_steps_products_product_fk"
  add_foreign_key "use_case_steps_products", "use_case_steps", name: "use_case_steps_products_step_fk"
  add_foreign_key "use_case_steps_workflows", "use_case_steps", name: "use_case_steps_workflows_step_fk"
  add_foreign_key "use_case_steps_workflows", "workflows", name: "use_case_steps_workflows_workflow_fk"
  add_foreign_key "use_cases", "sectors"
  add_foreign_key "use_cases_sdg_targets", "sdg_targets", name: "usecases_sdgs_sdg_fk"
  add_foreign_key "use_cases_sdg_targets", "use_cases", name: "usecases_sdgs_usecase_fk"
  add_foreign_key "users", "organizations", name: "user_organization_fk"
  add_foreign_key "users_products", "products", name: "users_products_product_fk"
  add_foreign_key "users_products", "users", name: "users_products_user_fk"
  add_foreign_key "workflow_descriptions", "workflows"
  add_foreign_key "workflows_building_blocks", "building_blocks", name: "workflows_bbs_bb_fk"
  add_foreign_key "workflows_building_blocks", "workflows", name: "workflows_bbs_workflow_fk"
end
