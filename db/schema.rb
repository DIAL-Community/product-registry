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

ActiveRecord::Schema.define(version: 20190413143731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_blocks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "products_building_blocks", id: false, force: :cascade do |t|
    t.bigint "building_block_id", null: false
    t.bigint "product_id", null: false
    t.index ["building_block_id", "product_id"], name: "block_prods", unique: true
    t.index ["product_id", "building_block_id"], name: "prod_blocks", unique: true
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_displayable"
    t.index ["slug"], name: "index_sectors_on_slug", unique: true
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "organizations_contacts", "contacts", name: "organizations_contacts_contact_fk"
  add_foreign_key "organizations_contacts", "organizations", name: "organizations_contacts_organization_fk"
  add_foreign_key "organizations_locations", "locations", name: "organizations_locations_location_fk"
  add_foreign_key "organizations_locations", "organizations", name: "organizations_locations_organization_fk"
  add_foreign_key "organizations_products", "organizations", name: "organizations_products_organization_fk"
  add_foreign_key "organizations_products", "products", name: "organizations_products_product_fk"
  add_foreign_key "organizations_sectors", "organizations", name: "organizations_sectors_organization_fk"
  add_foreign_key "organizations_sectors", "sectors", name: "organizations_sectors_sector_fk"
  add_foreign_key "product_assessments", "products"
  add_foreign_key "products_building_blocks", "building_blocks", name: "products_building_blocks_building_block_fk"
  add_foreign_key "products_building_blocks", "products", name: "products_building_blocks_product_fk"
end
