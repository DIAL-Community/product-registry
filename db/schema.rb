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

ActiveRecord::Schema.define(version: 20190408152727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_blocks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
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
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.point "points", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_type"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.datetime "when_endorsed"
    t.string "website"
    t.boolean "is_endorser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations_contacts", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.index ["contact_id", "organization_id"], name: "index_organizations_contacts_on_contact_id_and_organization_id"
    t.index ["organization_id", "contact_id"], name: "index_organizations_contacts_on_organization_id_and_contact_id"
  end

  create_table "organizations_locations", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "organization_id", null: false
    t.index ["location_id", "organization_id"], name: "loc_orcs"
    t.index ["organization_id", "location_id"], name: "org_locs"
  end

  create_table "organizations_products", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "product_id", null: false
    t.index ["organization_id", "product_id"], name: "index_organizations_products_on_organization_id_and_product_id"
    t.index ["product_id", "organization_id"], name: "index_organizations_products_on_product_id_and_organization_id"
  end

  create_table "organizations_sectors", id: false, force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id", "sector_id"], name: "org_sectors"
    t.index ["sector_id", "organization_id"], name: "sector_orcs"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products_building_blocks", id: false, force: :cascade do |t|
    t.bigint "building_block_id", null: false
    t.bigint "product_id", null: false
    t.index ["building_block_id", "product_id"], name: "block_prods"
    t.index ["product_id", "building_block_id"], name: "prod_blocks"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_displayable"
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

end
