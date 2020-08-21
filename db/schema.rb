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

ActiveRecord::Schema.define(version: 2020_08_19_002149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "playbook_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description"
    t.string "phase"
    t.jsonb "resources", default: [], null: false
    t.bigint "playbook_questions_id"
    t.integer "order"
    t.string "media_url"
    t.index ["playbook_id"], name: "index_activities_on_playbook_id"
    t.index ["playbook_questions_id"], name: "index_activities_on_playbook_questions_id"
  end

  create_table "activities_principles", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "digital_principle_id", null: false
    t.index ["activity_id", "digital_principle_id"], name: "activities_principles_idx", unique: true
    t.index ["digital_principle_id", "activity_id"], name: "principles_activities_idx", unique: true
  end

  create_table "activities_tasks", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "task_id", null: false
    t.index ["activity_id", "task_id"], name: "activities_tasks_idx", unique: true
    t.index ["task_id", "activity_id"], name: "tasks_activities_idx", unique: true
  end

  create_table "activity_descriptions", force: :cascade do |t|
    t.bigint "activity_id"
    t.string "locale", null: false
    t.string "description", default: "", null: false
    t.index ["activity_id"], name: "index_activity_descriptions_on_activity_id"
  end

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
    t.bigint "building_block_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["building_block_id"], name: "index_building_block_descriptions_on_building_block_id"
  end

# Could not dump table "building_blocks" because of following StandardError
#   Unknown type 'entity_status_type' for column 'maturity'

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

# Could not dump table "candidate_roles" because of following StandardError
#   Unknown type 'user_role' for column 'roles'

  create_table "category_indicator_descriptions", force: :cascade do |t|
    t.bigint "category_indicator_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.string "description_html"
    t.index ["category_indicator_id"], name: "index_category_indicator_descriptions_on_category_indicator_id"
  end

# Could not dump table "category_indicators" because of following StandardError
#   Unknown type 'category_indicator_type' for column 'indicator_type'

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "region_id"
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_cities_on_region_id"
  end

  create_table "classifications", force: :cascade do |t|
    t.string "name"
    t.string "indicator"
    t.string "description"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commontator_comments", force: :cascade do |t|
    t.bigint "thread_id", null: false
    t.string "creator_type", null: false
    t.bigint "creator_id", null: false
    t.string "editor_type"
    t.bigint "editor_id"
    t.text "body", null: false
    t.datetime "deleted_at"
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.index ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down"
    t.index ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up"
    t.index ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id"
    t.index ["editor_type", "editor_id"], name: "index_commontator_comments_on_editor_type_and_editor_id"
    t.index ["parent_id"], name: "index_commontator_comments_on_parent_id"
    t.index ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at"
  end

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.bigint "thread_id", null: false
    t.string "subscriber_type", null: false
    t.bigint "subscriber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true
    t.index ["thread_id"], name: "index_commontator_subscriptions_on_thread_id"
  end

  create_table "commontator_threads", force: :cascade do |t|
    t.string "commontable_type"
    t.bigint "commontable_id"
    t.string "closer_type"
    t.bigint "closer_id"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["closer_type", "closer_id"], name: "index_commontator_threads_on_closer_type_and_closer_id"
    t.index ["commontable_type", "commontable_id"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "email"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_contacts_on_slug", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "code", null: false
    t.string "code_longer", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "digital_principles", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "url", null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "region_id", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_districts_on_region_id"
  end

  create_table "ecto_schema_migrations", primary_key: "version", id: :bigint, default: nil, force: :cascade do |t|
    t.datetime "inserted_at", precision: 0
  end

  create_table "glossaries", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "locations" because of following StandardError
#   Unknown type 'location_type' for column 'location_type'

  create_table "maturity_rubric_descriptions", force: :cascade do |t|
    t.bigint "maturity_rubric_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.string "description_html"
    t.index ["maturity_rubric_id"], name: "index_maturity_rubric_descriptions_on_maturity_rubric_id"
  end

  create_table "maturity_rubrics", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offices", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "city", null: false
    t.bigint "organization_id", null: false
    t.bigint "region_id"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_offices_on_country_id"
    t.index ["organization_id"], name: "index_offices_on_organization_id"
    t.index ["region_id"], name: "index_offices_on_region_id"
  end

# Could not dump table "operator_services" because of following StandardError
#   Unknown type 'mobile_services' for column 'service'

  create_table "organization_descriptions", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_descriptions_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "when_endorsed"
    t.string "website"
    t.boolean "is_endorser", default: false
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

  create_table "organizations_countries", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_organizations_countries_on_country_id"
    t.index ["organization_id"], name: "index_organizations_countries_on_organization_id"
  end

  create_table "organizations_locations", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "organization_id", null: false
    t.boolean "migrated"
    t.datetime "migrated_date"
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

  create_table "organizations_states", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "region_id", null: false
    t.index ["organization_id"], name: "index_organizations_states_on_organization_id"
    t.index ["region_id"], name: "index_organizations_states_on_region_id"
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

  create_table "playbook_answers", force: :cascade do |t|
    t.bigint "playbook_questions_id"
    t.string "answer_text", null: false
    t.string "action", null: false
    t.integer "object_id"
    t.index ["playbook_questions_id"], name: "index_playbook_answers_on_playbook_questions_id"
  end

  create_table "playbook_descriptions", force: :cascade do |t|
    t.bigint "playbook_id"
    t.string "locale", null: false
    t.string "overview", default: ""
    t.string "audience", default: ""
    t.string "outcomes", default: ""
    t.index ["playbook_id"], name: "index_playbook_descriptions_on_playbook_id"
  end

  create_table "playbook_questions", force: :cascade do |t|
    t.string "question_text", null: false
  end

  create_table "playbooks", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "phases", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "maturity", default: "Beta"
  end

  create_table "plays", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description"
    t.string "author"
    t.jsonb "resources", default: [], null: false
    t.string "version", default: "1.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plays_tasks", force: :cascade do |t|
    t.bigint "play_id", null: false
    t.bigint "task_id", null: false
    t.index ["play_id", "task_id"], name: "plays_tasks_idx", unique: true
    t.index ["task_id", "play_id"], name: "tasks_plays_idx", unique: true
  end

  create_table "portal_views", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description", null: false
    t.string "top_navs", default: [], array: true
    t.string "filter_navs", default: [], array: true
    t.string "user_roles", default: [], array: true
    t.string "product_views", default: [], array: true
    t.string "organization_views", default: [], array: true
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "principle_descriptions", force: :cascade do |t|
    t.bigint "digital_principle_id"
    t.string "locale", null: false
    t.string "description", default: ""
    t.index ["digital_principle_id"], name: "index_principle_descriptions_on_digital_principle_id"
  end

# Could not dump table "product_building_blocks" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

  create_table "product_classifications", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "classification_id"
    t.index ["classification_id", "product_id"], name: "classifications_products_idx", unique: true
    t.index ["classification_id"], name: "index_product_classifications_on_classification_id"
    t.index ["product_id", "classification_id"], name: "products_classifications_idx", unique: true
    t.index ["product_id"], name: "index_product_classifications_on_product_id"
  end

  create_table "product_descriptions", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_descriptions_on_product_id"
  end

  create_table "product_indicators", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_indicator_id", null: false
    t.string "indicator_value", null: false
    t.index ["category_indicator_id"], name: "index_product_indicators_on_category_indicator_id"
    t.index ["product_id"], name: "index_product_indicators_on_product_id"
  end

# Could not dump table "product_product_relationships" because of following StandardError
#   Unknown type 'relationship_type' for column 'relationship_type'

# Could not dump table "product_sectors" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

  create_table "product_suites", force: :cascade do |t|
    t.string "name", null: false
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

# Could not dump table "product_sustainable_development_goals" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

  create_table "product_versions", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "version", null: false
    t.integer "version_order", null: false
    t.index ["product_id"], name: "index_product_versions_on_product_id"
  end

# Could not dump table "products" because of following StandardError
#   Unknown type 'product_type' for column 'product_type'

  create_table "products_origins", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "origin_id", null: false
    t.index ["origin_id", "product_id"], name: "origins_products_idx", unique: true
    t.index ["product_id", "origin_id"], name: "products_origins_idx", unique: true
  end

  create_table "project_descriptions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
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

  create_table "projects_countries", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_projects_countries_on_country_id"
    t.index ["project_id"], name: "index_projects_countries_on_project_id"
  end

  create_table "projects_locations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "location_id", null: false
    t.boolean "migrated"
    t.datetime "migrated_date"
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

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "country_id", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_regions_on_country_id"
  end

  create_table "rubric_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.decimal "weight", default: "0.0", null: false
    t.bigint "maturity_rubric_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maturity_rubric_id"], name: "index_rubric_categories_on_maturity_rubric_id"
  end

  create_table "rubric_category_descriptions", force: :cascade do |t|
    t.bigint "rubric_category_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.string "description_html"
    t.index ["rubric_category_id"], name: "index_rubric_category_descriptions_on_rubric_category_id"
  end

  create_table "sdg_targets", force: :cascade do |t|
    t.string "name", null: false
    t.string "target_number", null: false
    t.string "slug"
    t.integer "sdg_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
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
    t.jsonb "about_page", default: {}, null: false
    t.jsonb "footer_content", default: {}, null: false
    t.string "header_logo"
  end

  create_table "sustainable_development_goals", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "long_title", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_sdgs_on_slug", unique: true
  end

  create_table "tag_descriptions", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["tag_id"], name: "index_tag_descriptions_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_descriptions", force: :cascade do |t|
    t.bigint "task_id"
    t.string "locale", null: false
    t.string "description", default: ""
    t.string "prerequisites", default: ""
    t.string "outcomes", default: ""
    t.index ["task_id"], name: "index_task_descriptions_on_task_id"
  end

  create_table "task_tracker_descriptions", force: :cascade do |t|
    t.bigint "task_tracker_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["task_tracker_id"], name: "index_task_tracker_descriptions_on_task_tracker_id"
  end

  create_table "task_trackers", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "last_run"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description"
    t.boolean "complete", default: false
    t.date "due_date"
    t.jsonb "resources", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "playbook_questions_id"
    t.integer "order"
    t.string "media_url"
    t.index ["playbook_questions_id"], name: "index_tasks_on_playbook_questions_id"
  end

  create_table "tasks_organizations", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id", "task_id"], name: "organizations_plays_idx", unique: true
    t.index ["task_id", "organization_id"], name: "plays_organizations_idx", unique: true
  end

  create_table "tasks_products", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id", "task_id"], name: "products_tasks_idx", unique: true
    t.index ["task_id", "product_id"], name: "tasks_products_idx", unique: true
  end

  create_table "use_case_descriptions", force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["use_case_id"], name: "index_use_case_descriptions_on_use_case_id"
  end

  create_table "use_case_headers", force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.string "locale", null: false
    t.jsonb "header", default: {}, null: false
    t.index ["use_case_id"], name: "index_use_case_headers_on_use_case_id"
  end

  create_table "use_case_step_descriptions", force: :cascade do |t|
    t.bigint "use_case_step_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["use_case_step_id"], name: "index_use_case_step_descriptions_on_use_case_step_id"
  end

  create_table "use_case_steps", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "step_number", null: false
    t.bigint "use_case_id", null: false
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

# Could not dump table "use_cases" because of following StandardError
#   Unknown type 'entity_status_type' for column 'maturity'

  create_table "use_cases_sdg_targets", id: false, force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.bigint "sdg_target_id", null: false
    t.index ["sdg_target_id", "use_case_id"], name: "sdgs_usecases", unique: true
    t.index ["use_case_id", "sdg_target_id"], name: "usecases_sdgs", unique: true
  end

  create_table "user_events", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "email"
    t.datetime "event_datetime", null: false
    t.string "event_type", null: false
    t.jsonb "extended_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'user_role' for column 'role'

  create_table "users_products", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id", "user_id"], name: "products_users_idx", unique: true
    t.index ["user_id", "product_id"], name: "users_products_idx", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  create_table "workflow_descriptions", force: :cascade do |t|
    t.bigint "workflow_id", null: false
    t.string "locale", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["workflow_id"], name: "index_workflow_descriptions_on_workflow_id"
  end

  create_table "workflows", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: {}, null: false
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

  add_foreign_key "activities", "playbook_questions", column: "playbook_questions_id"
  add_foreign_key "activities", "playbooks"
  add_foreign_key "activities_principles", "activities", name: "principles_activities_phase_fk"
  add_foreign_key "activities_principles", "digital_principles", name: "principles_activities_principle_fk"
  add_foreign_key "activities_tasks", "activities", name: "activities_tasks_activity_fk"
  add_foreign_key "activities_tasks", "tasks", name: "activities_tasks_task_fk"
  add_foreign_key "activity_descriptions", "activities"
  add_foreign_key "aggregator_capabilities", "countries"
  add_foreign_key "aggregator_capabilities", "operator_services", column: "operator_services_id"
  add_foreign_key "aggregator_capabilities", "organizations", column: "aggregator_id"
  add_foreign_key "building_block_descriptions", "building_blocks"
  add_foreign_key "candidate_organizations", "users", column: "approved_by_id"
  add_foreign_key "candidate_organizations", "users", column: "rejected_by_id"
  add_foreign_key "candidate_roles", "users", column: "approved_by_id"
  add_foreign_key "candidate_roles", "users", column: "rejected_by_id"
  add_foreign_key "category_indicator_descriptions", "category_indicators"
  add_foreign_key "category_indicators", "rubric_categories"
  add_foreign_key "cities", "regions"
  add_foreign_key "commontator_comments", "commontator_comments", column: "parent_id", on_update: :restrict, on_delete: :cascade
  add_foreign_key "commontator_comments", "commontator_threads", column: "thread_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "commontator_subscriptions", "commontator_threads", column: "thread_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "deploys", "products"
  add_foreign_key "deploys", "users"
  add_foreign_key "districts", "regions"
  add_foreign_key "maturity_rubric_descriptions", "maturity_rubrics"
  add_foreign_key "offices", "countries"
  add_foreign_key "offices", "organizations"
  add_foreign_key "offices", "regions"
  add_foreign_key "operator_services", "countries"
  add_foreign_key "operator_services", "locations", column: "locations_id"
  add_foreign_key "organization_descriptions", "organizations"
  add_foreign_key "organizations_contacts", "contacts", name: "organizations_contacts_contact_fk"
  add_foreign_key "organizations_contacts", "organizations", name: "organizations_contacts_organization_fk"
  add_foreign_key "organizations_countries", "countries"
  add_foreign_key "organizations_countries", "organizations"
  add_foreign_key "organizations_locations", "locations", name: "organizations_locations_location_fk"
  add_foreign_key "organizations_locations", "organizations", name: "organizations_locations_organization_fk"
  add_foreign_key "organizations_products", "organizations", name: "organizations_products_organization_fk"
  add_foreign_key "organizations_products", "products", name: "organizations_products_product_fk"
  add_foreign_key "organizations_sectors", "organizations", name: "organizations_sectors_organization_fk"
  add_foreign_key "organizations_sectors", "sectors", name: "organizations_sectors_sector_fk"
  add_foreign_key "organizations_states", "organizations"
  add_foreign_key "organizations_states", "regions"
  add_foreign_key "playbook_answers", "playbook_questions", column: "playbook_questions_id"
  add_foreign_key "playbook_descriptions", "playbooks"
  add_foreign_key "plays_tasks", "plays", name: "tasks_plays_play_fk"
  add_foreign_key "plays_tasks", "tasks", name: "tasks_plays_task_fk"
  add_foreign_key "principle_descriptions", "digital_principles"
  add_foreign_key "product_building_blocks", "building_blocks", name: "products_building_blocks_building_block_fk"
  add_foreign_key "product_building_blocks", "products", name: "products_building_blocks_product_fk"
  add_foreign_key "product_classifications", "classifications"
  add_foreign_key "product_classifications", "classifications", name: "product_classifications_classification_fk"
  add_foreign_key "product_classifications", "products"
  add_foreign_key "product_classifications", "products", name: "product_classifications_product_fk"
  add_foreign_key "product_descriptions", "products"
  add_foreign_key "product_indicators", "category_indicators"
  add_foreign_key "product_indicators", "products"
  add_foreign_key "product_product_relationships", "products", column: "from_product_id", name: "from_product_fk"
  add_foreign_key "product_product_relationships", "products", column: "to_product_id", name: "to_product_fk"
  add_foreign_key "product_suites_product_versions", "product_suites", name: "pspv_product_suites_fk"
  add_foreign_key "product_suites_product_versions", "product_versions", name: "pspv_product_versions_fk"
  add_foreign_key "product_sustainable_development_goals", "products", name: "products_sdgs_product_fk"
  add_foreign_key "product_sustainable_development_goals", "sustainable_development_goals", name: "products_sdgs_sdg_fk"
  add_foreign_key "product_versions", "products"
  add_foreign_key "products_origins", "origins", name: "products_origins_origin_fk"
  add_foreign_key "products_origins", "products", name: "products_origins_product_fk"
  add_foreign_key "project_descriptions", "projects"
  add_foreign_key "projects", "origins"
  add_foreign_key "projects_countries", "countries"
  add_foreign_key "projects_countries", "projects"
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
  add_foreign_key "regions", "countries"
  add_foreign_key "rubric_categories", "maturity_rubrics"
  add_foreign_key "rubric_category_descriptions", "rubric_categories"
  add_foreign_key "tag_descriptions", "tags"
  add_foreign_key "task_descriptions", "tasks"
  add_foreign_key "task_tracker_descriptions", "task_trackers"
  add_foreign_key "tasks", "playbook_questions", column: "playbook_questions_id"
  add_foreign_key "tasks_organizations", "organizations", name: "organizations_tasks_org_fk"
  add_foreign_key "tasks_organizations", "tasks", name: "organizations_tasks_play_fk"
  add_foreign_key "tasks_products", "products", name: "products_tasks_product_fk"
  add_foreign_key "tasks_products", "tasks", name: "products_tasks_task_fk"
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
