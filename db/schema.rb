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

ActiveRecord::Schema.define(version: 2022_09_09_073617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "aggregator_capabilities" because of following StandardError
#   Unknown type 'mobile_services' for column 'service'

  create_table "audits", force: :cascade do |t|
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
    t.index ["action", "id", "version"], name: "auditable_index"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["user_id", "user_role"], name: "user_index"
  end

  create_table "building_block_descriptions", force: :cascade do |t|
    t.bigint "building_block_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
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
    t.string "description"
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

  create_table "candidate_products", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "website", null: false
    t.string "repository", null: false
    t.string "submitter_email", null: false
    t.boolean "rejected"
    t.datetime "rejected_date"
    t.bigint "rejected_by_id"
    t.datetime "approved_date"
    t.bigint "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["approved_by_id"], name: "index_candidate_products_on_approved_by_id"
    t.index ["rejected_by_id"], name: "index_candidate_products_on_rejected_by_id"
  end

# Could not dump table "candidate_roles" because of following StandardError
#   Unknown type 'user_role' for column 'roles'

  create_table "category_indicator_descriptions", force: :cascade do |t|
    t.bigint "category_indicator_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
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

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "classifications", force: :cascade do |t|
    t.string "name"
    t.string "indicator"
    t.string "description"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "comments" because of following StandardError
#   Unknown type 'comment_object_type' for column 'comment_object_type'

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

  create_table "dataset_descriptions", force: :cascade do |t|
    t.bigint "dataset_id"
    t.string "locale", null: false
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dataset_id"], name: "index_dataset_descriptions_on_dataset_id"
  end

# Could not dump table "dataset_sectors" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

# Could not dump table "dataset_sustainable_development_goals" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

  create_table "datasets", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "aliases", default: [], array: true
    t.string "website", null: false
    t.string "visualization_url"
    t.string "tags", default: [], array: true
    t.string "dataset_type", null: false
    t.string "geographic_coverage"
    t.string "time_range"
    t.boolean "manual_update", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "license"
    t.string "languages"
    t.string "data_format"
  end

  create_table "datasets_countries", force: :cascade do |t|
    t.bigint "dataset_id", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_datasets_countries_on_country_id"
    t.index ["dataset_id"], name: "index_datasets_countries_on_dataset_id"
  end

  create_table "datasets_origins", force: :cascade do |t|
    t.bigint "dataset_id", null: false
    t.bigint "origin_id", null: false
    t.index ["dataset_id"], name: "index_datasets_origins_on_dataset_id"
    t.index ["origin_id"], name: "index_datasets_origins_on_origin_id"
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

  create_table "dial_spreadsheet_data", force: :cascade do |t|
    t.string "slug", null: false
    t.string "spreadsheet_type", null: false
    t.jsonb "spreadsheet_data", default: {}, null: false
    t.boolean "deleted", default: false, null: false
    t.bigint "updated_by"
    t.datetime "updated_date"
  end

  create_table "digital_principles", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "url", null: false
    t.string "phase"
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

  create_table "endorsers", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "description"
  end

  create_table "froala_images", force: :cascade do |t|
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "glossaries", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "handbook_answers", force: :cascade do |t|
    t.string "answer_text", null: false
    t.string "action", null: false
    t.string "locale", default: "en", null: false
    t.bigint "handbook_question_id"
    t.index ["handbook_question_id"], name: "index_handbook_answers_on_handbook_question_id"
  end

  create_table "handbook_descriptions", force: :cascade do |t|
    t.bigint "handbook_id"
    t.string "locale", null: false
    t.string "overview", default: "", null: false
    t.string "audience", default: "", null: false
    t.string "outcomes", default: "", null: false
    t.string "cover"
    t.index ["handbook_id"], name: "index_handbook_descriptions_on_handbook_id"
  end

  create_table "handbook_pages", force: :cascade do |t|
    t.bigint "handbook_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "phase"
    t.integer "page_order"
    t.bigint "parent_page_id"
    t.bigint "handbook_questions_id"
    t.jsonb "resources", default: [], null: false
    t.string "media_url"
    t.index ["handbook_id"], name: "index_handbook_pages_on_handbook_id"
    t.index ["handbook_questions_id"], name: "index_handbook_pages_on_handbook_questions_id"
    t.index ["parent_page_id"], name: "index_handbook_pages_on_parent_page_id"
  end

  create_table "handbook_questions", force: :cascade do |t|
    t.string "question_text", null: false
    t.string "locale", default: "en", null: false
    t.bigint "handbook_page_id"
    t.index ["handbook_page_id"], name: "index_handbook_questions_on_handbook_page_id"
  end

  create_table "handbooks", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "phases", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "maturity", default: "Beta"
    t.string "pdf_url"
  end

  create_table "move_descriptions", force: :cascade do |t|
    t.bigint "play_move_id"
    t.string "locale", null: false
    t.string "description", null: false
    t.string "prerequisites", default: "", null: false
    t.string "outcomes", default: "", null: false
    t.index ["play_move_id"], name: "index_move_descriptions_on_play_move_id"
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
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_descriptions_on_organization_id"
  end

# Could not dump table "organizations" because of following StandardError
#   Unknown type 'endorser_type' for column 'endorser_level'

  create_table "organizations_contacts", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string "slug", null: false
  end

  create_table "organizations_countries", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_organizations_countries_on_country_id"
    t.index ["organization_id"], name: "index_organizations_countries_on_organization_id"
  end

# Could not dump table "organizations_datasets" because of following StandardError
#   Unknown type 'org_type' for column 'organization_type'

# Could not dump table "organizations_products" because of following StandardError
#   Unknown type 'org_type' for column 'org_type'

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

  create_table "page_contents", force: :cascade do |t|
    t.bigint "handbook_page_id"
    t.string "locale", null: false
    t.string "html", null: false
    t.string "css", null: false
    t.string "components"
    t.string "assets"
    t.string "styles"
    t.string "editor_type"
    t.index ["handbook_page_id"], name: "index_page_contents_on_handbook_page_id"
  end

  create_table "play_descriptions", force: :cascade do |t|
    t.bigint "play_id"
    t.string "locale", null: false
    t.string "description", null: false
    t.index ["play_id"], name: "index_play_descriptions_on_play_id"
  end

  create_table "play_moves", force: :cascade do |t|
    t.bigint "play_id"
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "order", null: false
    t.jsonb "resources", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_id"], name: "index_play_moves_on_play_id"
  end

  create_table "playbook_descriptions", force: :cascade do |t|
    t.bigint "playbook_id"
    t.string "locale", null: false
    t.string "overview", null: false
    t.string "audience", null: false
    t.string "outcomes", null: false
    t.index ["playbook_id"], name: "index_playbook_descriptions_on_playbook_id"
  end

  create_table "playbook_plays", force: :cascade do |t|
    t.bigint "playbook_id", null: false
    t.bigint "play_id", null: false
    t.string "phase"
    t.integer "order"
    t.index ["play_id"], name: "index_playbook_plays_on_play_id"
    t.index ["playbook_id"], name: "index_playbook_plays_on_playbook_id"
  end

  create_table "playbooks", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "phases", default: [], null: false
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "draft", default: true, null: false
    t.string "author"
  end

  create_table "playbooks_sectors", id: false, force: :cascade do |t|
    t.bigint "playbook_id", null: false
    t.bigint "sector_id", null: false
    t.index ["playbook_id", "sector_id"], name: "playbooks_sectors_idx", unique: true
    t.index ["sector_id", "playbook_id"], name: "sectors_playbooks_idx", unique: true
  end

  create_table "plays", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "author"
    t.jsonb "resources", default: [], null: false
    t.string "tags", default: [], array: true
    t.string "version", default: "1.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plays_building_blocks", force: :cascade do |t|
    t.bigint "play_id"
    t.bigint "building_block_id"
    t.index ["building_block_id", "play_id"], name: "bbs_plays_idx", unique: true
    t.index ["building_block_id"], name: "index_plays_building_blocks_on_building_block_id"
    t.index ["play_id", "building_block_id"], name: "plays_bbs_idx", unique: true
    t.index ["play_id"], name: "index_plays_building_blocks_on_play_id"
  end

  create_table "plays_products", force: :cascade do |t|
    t.bigint "play_id"
    t.bigint "product_id"
    t.index ["play_id", "product_id"], name: "plays_products_idx", unique: true
    t.index ["play_id"], name: "index_plays_products_on_play_id"
    t.index ["product_id", "play_id"], name: "products_plays_idx", unique: true
    t.index ["product_id"], name: "index_plays_products_on_product_id"
  end

  create_table "plays_subplays", force: :cascade do |t|
    t.bigint "parent_play_id", null: false
    t.bigint "child_play_id", null: false
    t.integer "order"
    t.index ["parent_play_id", "child_play_id"], name: "play_rel_index", unique: true
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
    t.string "description", default: "", null: false
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
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_descriptions_on_product_id"
  end

  create_table "product_indicators", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_indicator_id", null: false
    t.string "indicator_value", null: false
    t.datetime "updated_at"
    t.index ["category_indicator_id"], name: "index_product_indicators_on_category_indicator_id"
    t.index ["product_id"], name: "index_product_indicators_on_product_id"
  end

# Could not dump table "product_product_relationships" because of following StandardError
#   Unknown type 'relationship_type' for column 'relationship_type'

  create_table "product_repositories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "product_id", null: false
    t.string "absolute_url", null: false
    t.string "description", null: false
    t.boolean "main_repository", default: false, null: false
    t.jsonb "dpga_data", default: {}, null: false
    t.jsonb "language_data", default: {}, null: false
    t.jsonb "statistical_data", default: {}, null: false
    t.jsonb "license_data", default: {}, null: false
    t.string "license", default: "NA", null: false
    t.integer "code_lines"
    t.integer "cocomo"
    t.integer "est_hosting"
    t.integer "est_invested"
    t.datetime "updated_at", null: false
    t.bigint "updated_by"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.bigint "deleted_by"
    t.datetime "created_at", null: false
    t.index ["product_id"], name: "index_product_repositories_on_product_id"
  end

# Could not dump table "product_sectors" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

# Could not dump table "product_sustainable_development_goals" because of following StandardError
#   Unknown type 'mapping_status_type' for column 'mapping_status'

# Could not dump table "products" because of following StandardError
#   Unknown type 'product_type_save' for column 'product_type'

  create_table "products_endorsers", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "endorser_id", null: false
    t.index ["endorser_id"], name: "index_products_endorsers_on_endorser_id"
    t.index ["product_id"], name: "index_products_endorsers_on_product_id"
  end

  create_table "products_origins", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "origin_id", null: false
    t.index ["origin_id", "product_id"], name: "origins_products_idx", unique: true
    t.index ["product_id", "origin_id"], name: "products_origins_idx", unique: true
  end

  create_table "project_descriptions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
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
    t.string "project_url"
    t.string "tags", default: [], array: true
    t.index ["origin_id"], name: "index_projects_on_origin_id"
  end

  create_table "projects_countries", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_projects_countries_on_country_id"
    t.index ["project_id"], name: "index_projects_countries_on_project_id"
  end

  create_table "projects_digital_principles", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "digital_principle_id", null: false
    t.index ["digital_principle_id"], name: "index_projects_digital_principles_on_digital_principle_id"
    t.index ["project_id"], name: "index_projects_digital_principles_on_project_id"
  end

# Could not dump table "projects_organizations" because of following StandardError
#   Unknown type 'org_type' for column 'org_type'

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

  create_table "resources", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "phase", null: false
    t.string "image_url"
    t.string "link"
    t.string "description"
  end

  create_table "rubric_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.decimal "weight", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rubric_category_descriptions", force: :cascade do |t|
    t.bigint "rubric_category_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
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
    t.bigint "parent_sector_id"
    t.bigint "origin_id"
    t.string "locale", default: "en"
    t.index ["origin_id"], name: "index_sectors_on_origin_id"
    t.index ["parent_sector_id"], name: "index_sectors_on_parent_sector_id"
    t.index ["slug", "origin_id", "parent_sector_id", "locale"], name: "index_sector_slug_unique", unique: true
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
    t.string "about_page", default: "", null: false
    t.string "footer_content", default: "", null: false
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
    t.string "description", default: "", null: false
    t.index ["tag_id"], name: "index_tag_descriptions_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "use_case_descriptions", force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
    t.index ["use_case_id"], name: "index_use_case_descriptions_on_use_case_id"
  end

  create_table "use_case_headers", force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.string "locale", null: false
    t.string "header", default: "", null: false
    t.index ["use_case_id"], name: "index_use_case_headers_on_use_case_id"
  end

  create_table "use_case_step_descriptions", force: :cascade do |t|
    t.bigint "use_case_step_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
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

  create_table "use_case_steps_building_blocks", force: :cascade do |t|
    t.bigint "use_case_step_id", null: false
    t.bigint "building_block_id", null: false
    t.index ["building_block_id", "use_case_step_id"], name: "building_blocks_use_case_steps_idx", unique: true
    t.index ["use_case_step_id", "building_block_id"], name: "use_case_steps_building_blocks_idx", unique: true
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

  create_table "workflow_descriptions", force: :cascade do |t|
    t.bigint "workflow_id", null: false
    t.string "locale", null: false
    t.string "description", default: "", null: false
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

  add_foreign_key "aggregator_capabilities", "countries"
  add_foreign_key "aggregator_capabilities", "operator_services", column: "operator_services_id"
  add_foreign_key "aggregator_capabilities", "organizations", column: "aggregator_id"
  add_foreign_key "building_block_descriptions", "building_blocks"
  add_foreign_key "candidate_organizations", "users", column: "approved_by_id"
  add_foreign_key "candidate_organizations", "users", column: "rejected_by_id"
  add_foreign_key "candidate_products", "users", column: "approved_by_id"
  add_foreign_key "candidate_products", "users", column: "rejected_by_id"
  add_foreign_key "candidate_roles", "organizations"
  add_foreign_key "candidate_roles", "products"
  add_foreign_key "candidate_roles", "users", column: "approved_by_id"
  add_foreign_key "candidate_roles", "users", column: "rejected_by_id"
  add_foreign_key "category_indicator_descriptions", "category_indicators"
  add_foreign_key "category_indicators", "rubric_categories"
  add_foreign_key "cities", "regions"
  add_foreign_key "dataset_descriptions", "datasets"
  add_foreign_key "dataset_sectors", "datasets"
  add_foreign_key "dataset_sectors", "sectors"
  add_foreign_key "datasets_countries", "countries"
  add_foreign_key "datasets_countries", "datasets"
  add_foreign_key "datasets_origins", "datasets"
  add_foreign_key "datasets_origins", "origins"
  add_foreign_key "deploys", "products"
  add_foreign_key "deploys", "users"
  add_foreign_key "districts", "regions"
  add_foreign_key "handbook_descriptions", "handbooks"
  add_foreign_key "handbook_pages", "handbook_pages", column: "parent_page_id"
  add_foreign_key "handbook_pages", "handbook_questions", column: "handbook_questions_id"
  add_foreign_key "handbook_pages", "handbooks"
  add_foreign_key "move_descriptions", "play_moves"
  add_foreign_key "offices", "countries"
  add_foreign_key "offices", "organizations"
  add_foreign_key "offices", "regions"
  add_foreign_key "operator_services", "countries"
  add_foreign_key "organization_descriptions", "organizations"
  add_foreign_key "organizations_contacts", "contacts", name: "organizations_contacts_contact_fk"
  add_foreign_key "organizations_contacts", "organizations", name: "organizations_contacts_organization_fk"
  add_foreign_key "organizations_countries", "countries"
  add_foreign_key "organizations_countries", "organizations"
  add_foreign_key "organizations_datasets", "datasets"
  add_foreign_key "organizations_datasets", "organizations"
  add_foreign_key "organizations_products", "organizations", name: "organizations_products_organization_fk"
  add_foreign_key "organizations_products", "products", name: "organizations_products_product_fk"
  add_foreign_key "organizations_sectors", "organizations", name: "organizations_sectors_organization_fk"
  add_foreign_key "organizations_sectors", "sectors", name: "organizations_sectors_sector_fk"
  add_foreign_key "organizations_states", "organizations"
  add_foreign_key "organizations_states", "regions"
  add_foreign_key "page_contents", "handbook_pages"
  add_foreign_key "play_descriptions", "plays"
  add_foreign_key "play_moves", "plays"
  add_foreign_key "playbook_descriptions", "playbooks"
  add_foreign_key "playbook_plays", "playbooks"
  add_foreign_key "playbook_plays", "plays"
  add_foreign_key "playbooks_sectors", "playbooks", name: "playbooks_sectors_playbook_fk"
  add_foreign_key "playbooks_sectors", "sectors", name: "playbooks_sectors_sector_fk"
  add_foreign_key "plays_building_blocks", "building_blocks"
  add_foreign_key "plays_building_blocks", "building_blocks", name: "bbs_plays_bb_fk"
  add_foreign_key "plays_building_blocks", "plays"
  add_foreign_key "plays_building_blocks", "plays", name: "bbs_plays_play_fk"
  add_foreign_key "plays_products", "plays"
  add_foreign_key "plays_products", "plays", name: "products_plays_play_fk"
  add_foreign_key "plays_products", "products"
  add_foreign_key "plays_products", "products", name: "products_plays_product_fk"
  add_foreign_key "plays_subplays", "plays", column: "child_play_id", name: "child_play_fk"
  add_foreign_key "plays_subplays", "plays", column: "parent_play_id", name: "parent_play_fk"
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
  add_foreign_key "product_repositories", "products"
  add_foreign_key "product_sustainable_development_goals", "products", name: "products_sdgs_product_fk"
  add_foreign_key "product_sustainable_development_goals", "sustainable_development_goals", name: "products_sdgs_sdg_fk"
  add_foreign_key "products_endorsers", "endorsers"
  add_foreign_key "products_endorsers", "products"
  add_foreign_key "products_origins", "origins", name: "products_origins_origin_fk"
  add_foreign_key "products_origins", "products", name: "products_origins_product_fk"
  add_foreign_key "project_descriptions", "projects"
  add_foreign_key "projects", "origins"
  add_foreign_key "projects_countries", "countries"
  add_foreign_key "projects_countries", "projects"
  add_foreign_key "projects_digital_principles", "digital_principles"
  add_foreign_key "projects_digital_principles", "projects"
  add_foreign_key "projects_organizations", "organizations", name: "projects_organizations_organization_fk"
  add_foreign_key "projects_organizations", "projects", name: "projects_organizations_project_fk"
  add_foreign_key "projects_products", "products", name: "projects_products_product_fk"
  add_foreign_key "projects_products", "projects", name: "projects_products_project_fk"
  add_foreign_key "projects_sdgs", "projects", name: "projects_sdgs_project_fk"
  add_foreign_key "projects_sdgs", "sustainable_development_goals", column: "sdg_id", name: "projects_sdgs_sdg_fk"
  add_foreign_key "projects_sectors", "projects", name: "projects_sectors_project_fk"
  add_foreign_key "projects_sectors", "sectors", name: "projects_sectors_sector_fk"
  add_foreign_key "regions", "countries"
  add_foreign_key "rubric_category_descriptions", "rubric_categories"
  add_foreign_key "sectors", "origins"
  add_foreign_key "sectors", "sectors", column: "parent_sector_id"
  add_foreign_key "tag_descriptions", "tags"
  add_foreign_key "task_tracker_descriptions", "task_trackers"
  add_foreign_key "use_case_descriptions", "use_cases"
  add_foreign_key "use_case_headers", "use_cases"
  add_foreign_key "use_case_step_descriptions", "use_case_steps"
  add_foreign_key "use_case_steps", "use_cases"
  add_foreign_key "use_case_steps_building_blocks", "building_blocks", name: "use_case_steps_building_blocks_block_fk"
  add_foreign_key "use_case_steps_building_blocks", "use_case_steps", name: "use_case_steps_building_blocks_step_fk"
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
