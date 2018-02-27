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

ActiveRecord::Schema.define(version: 20180227073348) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "address_type"
    t.string "employer"
    t.string "street1"
    t.string "street2"
    t.boolean "primary"
    t.string "street_address"
    t.string "city"
    t.string "state_province"
    t.string "country"
    t.string "postal_code"
    t.string "phone_number"
    t.boolean "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_type"], name: "index_addresses_on_address_type"
    t.index ["enable"], name: "index_addresses_on_enable"
  end

  create_table "auths", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "secure_random"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_auths_on_user_id"
  end

  create_table "citizenships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_citizenships_on_name"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "content", limit: 500
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "concepts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "url"
    t.text "summary"
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by"], name: "index_concepts_on_created_by"
    t.index ["user_id"], name: "index_concepts_on_user_id"
  end

  create_table "invention_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "invention_id"
    t.bigint "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_invention_comments_on_comment_id"
    t.index ["invention_id"], name: "index_invention_comments_on_invention_id"
  end

  create_table "invention_opportunities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "organization_id"
    t.string "title"
    t.date "closing_date"
    t.string "short_description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["closing_date"], name: "index_invention_opportunities_on_closing_date"
    t.index ["organization_id"], name: "index_invention_opportunities_on_organization_id"
    t.index ["status"], name: "index_invention_opportunities_on_status"
    t.index ["title"], name: "index_invention_opportunities_on_title"
  end

  create_table "invention_opportunity_upload_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "invention_opportunity_id"
    t.bigint "upload_file_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invention_opportunity_id"], name: "invention_opportunity_id"
    t.index ["status"], name: "index_invention_opportunity_upload_files_on_status"
    t.index ["upload_file_id"], name: "index_invention_opportunity_upload_files_on_upload_file_id"
  end

  create_table "invention_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "invention_id"
    t.bigint "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invention_id"], name: "index_invention_searches_on_invention_id"
    t.index ["search_id"], name: "index_invention_searches_on_search_id"
  end

  create_table "invention_upload_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "invention_id"
    t.bigint "upload_file_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invention_id"], name: "index_invention_upload_files_on_invention_id"
    t.index ["status"], name: "index_invention_upload_files_on_status"
    t.index ["upload_file_id"], name: "index_invention_upload_files_on_upload_file_id"
  end

  create_table "inventions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "invention_opportunity_id"
    t.bigint "organization_id"
    t.string "name"
    t.string "title"
    t.string "description"
    t.string "action"
    t.string "level"
    t.string "action_note", limit: 500
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invention_opportunity_id"], name: "index_inventions_on_invention_opportunity_id"
    t.index ["organization_id"], name: "index_inventions_on_organization_id"
  end

  create_table "languages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_languages_on_name"
  end

  create_table "organization_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "organization_id"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_organization_addresses_on_address_id"
    t.index ["organization_id"], name: "index_organization_addresses_on_organization_id"
  end

  create_table "organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.string "time_zone"
    t.string "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name"
  end

  create_table "phones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "address_id"
    t.string "phone_type"
    t.string "phone_number"
    t.boolean "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_phones_on_address_id"
    t.index ["enable"], name: "index_phones_on_enable"
    t.index ["phone_type"], name: "index_phones_on_phone_type"
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.string "role_type"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "url"
    t.string "note"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note"], name: "index_searches_on_note"
    t.index ["tag"], name: "index_searches_on_tag"
    t.index ["title"], name: "index_searches_on_title"
    t.index ["url"], name: "index_searches_on_url"
  end

  create_table "solutions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "concept_id"
    t.text "summary"
    t.text "significance"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "index_solutions_on_concept_id"
    t.index ["created_by"], name: "index_solutions_on_created_by"
    t.index ["updated_by"], name: "index_solutions_on_updated_by"
  end

  create_table "time_zones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_time_zones_on_name"
  end

  create_table "upload_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.string "filepath"
    t.boolean "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "upload_file_name"
    t.string "upload_content_type"
    t.integer "upload_file_size"
    t.datetime "upload_updated_at"
    t.index ["enable"], name: "index_upload_files_on_enable"
    t.index ["filepath"], name: "index_upload_files_on_filepath"
    t.index ["name"], name: "index_upload_files_on_name"
  end

  create_table "user_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_user_addresses_on_address_id"
    t.index ["user_id"], name: "index_user_addresses_on_user_id"
  end

  create_table "user_citizenships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "citizenship_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["citizenship_id"], name: "index_user_citizenships_on_citizenship_id"
    t.index ["user_id"], name: "index_user_citizenships_on_user_id"
  end

  create_table "user_inventions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "invention_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invention_id"], name: "index_user_inventions_on_invention_id"
    t.index ["role_id"], name: "index_user_inventions_on_role_id"
    t.index ["user_id"], name: "index_user_inventions_on_user_id"
  end

  create_table "user_languages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "user_organization_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.string "status", default: "Active"
    t.string "title"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_user_organization_statuses_on_organization_id"
    t.index ["user_id"], name: "index_user_organization_statuses_on_user_id"
  end

  create_table "user_organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["role_id"], name: "index_user_organizations_on_role_id"
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "user_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "citizenship"
    t.string "status", default: "Active"
    t.string "screen_name"
    t.string "employer"
    t.string "time_zone"
    t.string "resume_filepath"
    t.text "personal_summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "access_token"
    t.datetime "expires_at"
    t.boolean "enable", default: true
    t.string "resume_file_name"
    t.string "resume_content_type"
    t.integer "resume_file_size"
    t.datetime "resume_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
