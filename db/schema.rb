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

ActiveRecord::Schema.define(version: 20190730155346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_blocks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["slug"], name: "index_building_blocks_on_slug", unique: true
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

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.point "points", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location_type", limit: 16
    t.index ["slug"], name: "index_locations_on_slug", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.datetime "when_endorsed"
    t.string "website"
    t.boolean "is_endorser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "organizations_contacts", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.index ["contact_id", "organization_id"], name: "index_organizations_contacts_on_contact_id_and_organization_id", unique: true
    t.index ["organization_id", "contact_id"], name: "index_organizations_contacts_on_organization_id_and_contact_id", unique: true
  end

  create_table "organizations_locations", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "organization_id", null: false
    t.index ["location_id", "organization_id"], name: "loc_orcs", unique: true
    t.index ["organization_id", "location_id"], name: "org_locs", unique: true
  end

  create_table "organizations_products", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "product_id", null: false
    t.index ["organization_id", "product_id"], name: "index_organizations_products_on_organization_id_and_product_id", unique: true
    t.index ["product_id", "organization_id"], name: "index_organizations_products_on_product_id_and_organization_id", unique: true
  end

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

  create_table "product_assessments", force: :cascade do |t|
    t.bigint "product_id"
    t.boolean "has_osc"
    t.boolean "has_digisquare"
    t.boolean "osc_cd10"
    t.boolean "osc_cd20"
    t.boolean "osc_cd21"
    t.boolean "osc_cd30"
    t.boolean "osc_cd31"
    t.boolean "osc_cd40"
    t.boolean "osc_cd50"
    t.boolean "osc_cd60"
    t.boolean "osc_cd61"
    t.boolean "osc_lc10"
    t.boolean "osc_lc20"
    t.boolean "osc_lc30"
    t.boolean "osc_lc40"
    t.boolean "osc_lc50"
    t.boolean "osc_lc60"
    t.boolean "osc_re10"
    t.boolean "osc_re30"
    t.boolean "osc_re40"
    t.boolean "osc_re50"
    t.boolean "osc_re60"
    t.boolean "osc_re70"
    t.boolean "osc_re80"
    t.boolean "osc_qu10"
    t.boolean "osc_qu11"
    t.boolean "osc_qu12"
    t.boolean "osc_qu20"
    t.boolean "osc_qu30"
    t.boolean "osc_qu40"
    t.boolean "osc_qu50"
    t.boolean "osc_qu51"
    t.boolean "osc_qu52"
    t.boolean "osc_qu60"
    t.boolean "osc_qu70"
    t.boolean "osc_qu71"
    t.boolean "osc_qu80"
    t.boolean "osc_qu90"
    t.boolean "osc_qu100"
    t.boolean "osc_co10"
    t.boolean "osc_co20"
    t.boolean "osc_co30"
    t.boolean "osc_co40"
    t.boolean "osc_co50"
    t.boolean "osc_co60"
    t.boolean "osc_co70"
    t.boolean "osc_co71"
    t.boolean "osc_co72"
    t.boolean "osc_co73"
    t.boolean "osc_co80"
    t.boolean "osc_cs10"
    t.boolean "osc_cs20"
    t.boolean "osc_cs30"
    t.boolean "osc_cs40"
    t.boolean "osc_cs50"
    t.boolean "osc_in10"
    t.boolean "osc_in20"
    t.boolean "osc_in30"
    t.boolean "osc_im10"
    t.boolean "osc_im20"
    t.integer "digisquare_country_utilization"
    t.integer "digisquare_country_strategy"
    t.integer "digisquare_digital_health_interventions"
    t.integer "digisquare_source_code_accessibility"
    t.integer "digisquare_funding_and_revenue"
    t.integer "digisquare_developer_contributor_and_implementor_community_enga"
    t.integer "digisquare_community_governance"
    t.integer "digisquare_software_roadmap"
    t.integer "digisquare_user_documentation"
    t.integer "digisquare_multilingual_support"
    t.integer "digisquare_technical_documentation"
    t.integer "digisquare_software_productization"
    t.integer "digisquare_interoperability_and_data_accessibility"
    t.integer "digisquare_security"
    t.integer "digisquare_scalability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_assessments_on_product_id"
  end

  create_table "product_product_relationships", force: :cascade do |t|
    t.bigint "from_product_id", null: false
    t.bigint "to_product_id", null: false
    t.string "relationship_type", limit: 16, null: false
    t.index ["from_product_id", "to_product_id"], name: "product_rel_index", unique: true
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
    t.index ["product_id", "sustainable_development_goal_id"], name: "prod_sdgs", unique: true
    t.index ["sustainable_development_goal_id", "product_id"], name: "sdgs_prods", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "origin_id"
    t.date "start_date"
    t.date "end_date"
    t.decimal "budget", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "description", null: false
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

  create_table "sustainable_development_goals", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "long_title"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_sdgs_on_slug", unique: true
  end

  create_table "use_cases", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: "{}", null: false
    t.index ["sector_id"], name: "index_use_cases_on_sector_id"
  end

  create_table "use_cases_sdg_targets", id: false, force: :cascade do |t|
    t.bigint "use_case_id", null: false
    t.bigint "sdg_target_id", null: false
    t.index ["sdg_target_id", "use_case_id"], name: "sdgs_usecases", unique: true
    t.index ["use_case_id", "sdg_target_id"], name: "usecases_sdgs", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 3, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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

  add_foreign_key "deploys", "products"
  add_foreign_key "deploys", "users"
  add_foreign_key "organizations_contacts", "contacts", name: "organizations_contacts_contact_fk"
  add_foreign_key "organizations_contacts", "organizations", name: "organizations_contacts_organization_fk"
  add_foreign_key "organizations_locations", "locations", name: "organizations_locations_location_fk"
  add_foreign_key "organizations_locations", "organizations", name: "organizations_locations_organization_fk"
  add_foreign_key "organizations_products", "organizations", name: "organizations_products_organization_fk"
  add_foreign_key "organizations_products", "products", name: "organizations_products_product_fk"
  add_foreign_key "organizations_sectors", "organizations", name: "organizations_sectors_organization_fk"
  add_foreign_key "organizations_sectors", "sectors", name: "organizations_sectors_sector_fk"
  add_foreign_key "product_assessments", "products"
  add_foreign_key "product_product_relationships", "products", column: "from_product_id", name: "from_product_fk"
  add_foreign_key "product_product_relationships", "products", column: "to_product_id", name: "to_product_fk"
  add_foreign_key "products_building_blocks", "building_blocks", name: "products_building_blocks_building_block_fk"
  add_foreign_key "products_building_blocks", "products", name: "products_building_blocks_product_fk"
  add_foreign_key "products_origins", "origins", name: "products_origins_origin_fk"
  add_foreign_key "products_origins", "products", name: "products_origins_product_fk"
  add_foreign_key "products_sustainable_development_goals", "products", name: "products_sdgs_product_fk"
  add_foreign_key "products_sustainable_development_goals", "sustainable_development_goals", name: "products_sdgs_sdg_fk"
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
  add_foreign_key "use_cases", "sectors"
  add_foreign_key "use_cases_sdg_targets", "sdg_targets", name: "usecases_sdgs_sdg_fk"
  add_foreign_key "use_cases_sdg_targets", "use_cases", name: "usecases_sdgs_usecase_fk"
  add_foreign_key "workflows_building_blocks", "building_blocks", name: "workflows_bbs_bb_fk"
  add_foreign_key "workflows_building_blocks", "workflows", name: "workflows_bbs_workflow_fk"
  add_foreign_key "workflows_use_cases", "use_cases", name: "workflows_usecases_usecase_fk"
  add_foreign_key "workflows_use_cases", "workflows", name: "workflows_usecases_workflow_fk"
end
