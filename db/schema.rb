# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_emailaddress", id: :integer, default: nil, force: :cascade do |t|
    t.string "email", limit: 254, null: false
    t.boolean "verified", null: false
    t.boolean "primary", null: false
    t.integer "user_id", null: false
    t.index ["email"], name: "account_emailaddress_email_03be32b2"
    t.index ["email"], name: "account_emailaddress_email_03be32b2_like", opclass: :varchar_pattern_ops
    t.index ["email"], name: "unique_verified_email", unique: true, where: "verified"
    t.index ["user_id", "primary"], name: "unique_primary_email", unique: true, where: "\"primary\""
    t.index ["user_id"], name: "account_emailaddress_user_id_2c513194"
    t.unique_constraint ["user_id", "email"], name: "account_emailaddress_user_id_email_987c8728_uniq"
  end

  create_table "account_emailconfirmation", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created", null: false
    t.timestamptz "sent"
    t.string "key", limit: 64, null: false
    t.integer "email_address_id", null: false
    t.index ["email_address_id"], name: "account_emailconfirmation_email_address_id_5b7f8c58"
    t.index ["key"], name: "account_emailconfirmation_key_f43612bd_like", opclass: :varchar_pattern_ops
    t.unique_constraint ["key"], name: "account_emailconfirmation_key_key"
  end

  create_table "auth_group", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.index ["name"], name: "auth_group_name_a6ea08ec_like", opclass: :varchar_pattern_ops
    t.unique_constraint ["name"], name: "auth_group_name_key"
  end

  create_table "auth_group_permissions", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "permission_id", null: false
    t.index ["group_id"], name: "auth_group_permissions_group_id_b120cbf9"
    t.index ["permission_id"], name: "auth_group_permissions_permission_id_84c5c92e"
    t.unique_constraint ["group_id", "permission_id"], name: "auth_group_permissions_group_id_permission_id_0cd325b0_uniq"
  end

  create_table "auth_permission", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "content_type_id", null: false
    t.string "codename", limit: 100, null: false
    t.index ["content_type_id"], name: "auth_permission_content_type_id_2f476e4b"
    t.unique_constraint ["content_type_id", "codename"], name: "auth_permission_content_type_id_codename_01ab375a_uniq"
  end

  create_table "auth_user", id: :integer, default: nil, force: :cascade do |t|
    t.string "password", limit: 128, null: false
    t.timestamptz "last_login"
    t.boolean "is_superuser", null: false
    t.string "username", limit: 150, null: false
    t.string "first_name", limit: 150, null: false
    t.string "last_name", limit: 150, null: false
    t.string "email", limit: 254, null: false
    t.boolean "is_staff", null: false
    t.boolean "is_active", null: false
    t.timestamptz "date_joined", null: false
    t.index ["username"], name: "auth_user_username_6821ab7c_like", opclass: :varchar_pattern_ops
    t.unique_constraint ["username"], name: "auth_user_username_key"
  end

  create_table "auth_user_groups", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "auth_user_groups_group_id_97559544"
    t.index ["user_id"], name: "auth_user_groups_user_id_6a12ed8b"
    t.unique_constraint ["user_id", "group_id"], name: "auth_user_groups_user_id_group_id_94350c0c_uniq"
  end

  create_table "auth_user_user_permissions", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "permission_id", null: false
    t.index ["permission_id"], name: "auth_user_user_permissions_permission_id_1fbb5f2c"
    t.index ["user_id"], name: "auth_user_user_permissions_user_id_a95ead1b"
    t.unique_constraint ["user_id", "permission_id"], name: "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq"
  end

  create_table "django_admin_log", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "action_time", null: false
    t.text "object_id"
    t.string "object_repr", limit: 200, null: false
    t.integer "action_flag", limit: 2, null: false
    t.text "change_message", null: false
    t.integer "content_type_id"
    t.integer "user_id", null: false
    t.index ["content_type_id"], name: "django_admin_log_content_type_id_c4bce8eb"
    t.index ["user_id"], name: "django_admin_log_user_id_c564eba6"
    t.check_constraint "action_flag >= 0", name: "django_admin_log_action_flag_check"
  end

  create_table "django_content_type", id: :integer, default: nil, force: :cascade do |t|
    t.string "app_label", limit: 100, null: false
    t.string "model", limit: 100, null: false

    t.unique_constraint ["app_label", "model"], name: "django_content_type_app_label_model_76bd3d3b_uniq"
  end

  create_table "django_migrations", id: :bigint, default: nil, force: :cascade do |t|
    t.string "app", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.timestamptz "applied", null: false
  end

  create_table "django_session", primary_key: "session_key", id: { type: :string, limit: 40 }, force: :cascade do |t|
    t.text "session_data", null: false
    t.timestamptz "expire_date", null: false
    t.index ["expire_date"], name: "django_session_expire_date_a5c62663"
    t.index ["session_key"], name: "django_session_session_key_c0390e0f_like", opclass: :varchar_pattern_ops
  end

  create_table "django_site", id: :integer, default: nil, force: :cascade do |t|
    t.string "domain", limit: 100, null: false
    t.string "name", limit: 50, null: false
    t.index ["domain"], name: "django_site_domain_a2e37b91_like", opclass: :varchar_pattern_ops
    t.unique_constraint ["domain"], name: "django_site_domain_a2e37b91_uniq"
  end

  create_table "reviews_author", primary_key: "person_id", id: :integer, default: nil, force: :cascade do |t|
    t.string "first_name", limit: 100, null: false
    t.string "last_name", limit: 100, null: false
    t.string "first_name_reading", limit: 100, null: false
    t.string "last_name_reading", limit: 100, null: false
    t.string "first_name_sorting", limit: 100, null: false
    t.string "last_name_sorting", limit: 100, null: false
  end

  create_table "reviews_work", id: :bigint, default: nil, force: :cascade do |t|
    t.string "title", limit: 256, null: false
    t.string "title_reading", limit: 256, null: false
    t.string "title_sorting", limit: 256, null: false
    t.string "sub_title", limit: 256
    t.string "sub_title_reading", limit: 256
    t.string "original_title", limit: 256
    t.string "classification_number", limit: 50
    t.string "character_usage", limit: 50, null: false
    t.boolean "copyright_flag", null: false
    t.date "release_date"
    t.date "last_updated"
    t.string "book_card_url", limit: 200, null: false
    t.string "text_file_url", limit: 200
    t.string "html_file_url", limit: 200
    t.integer "author_id", null: false
    t.integer "translator_id"
    t.string "role_flag", limit: 50, null: false
    t.index ["author_id"], name: "reviews_work_author_id_2ff6ff3d"
    t.index ["translator_id"], name: "reviews_work_translator_id_a3674e09"
    t.unique_constraint ["title", "sub_title"], name: "reviews_work_title_sub_title_5e998e17_uniq"
  end

  create_table "socialaccount_socialaccount", id: :integer, default: nil, force: :cascade do |t|
    t.string "provider", limit: 200, null: false
    t.string "uid", limit: 191, null: false
    t.timestamptz "last_login", null: false
    t.timestamptz "date_joined", null: false
    t.jsonb "extra_data", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "socialaccount_socialaccount_user_id_8146e70c"
    t.unique_constraint ["provider", "uid"], name: "socialaccount_socialaccount_provider_uid_fc810c6e_uniq"
  end

  create_table "socialaccount_socialapp", id: :integer, default: nil, force: :cascade do |t|
    t.string "provider", limit: 30, null: false
    t.string "provider_id", limit: 200, null: false
    t.string "name", limit: 40, null: false
    t.string "client_id", limit: 191, null: false
    t.string "secret", limit: 191, null: false
    t.string "key", limit: 191, null: false
    t.jsonb "settings", null: false
  end

  create_table "socialaccount_socialapp_sites", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "socialapp_id", null: false
    t.integer "site_id", null: false
    t.index ["site_id"], name: "socialaccount_socialapp_sites_site_id_2579dee5"
    t.index ["socialapp_id"], name: "socialaccount_socialapp_sites_socialapp_id_97fb6e7d"
    t.unique_constraint ["socialapp_id", "site_id"], name: "socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq"
  end

  create_table "socialaccount_socialtoken", id: :integer, default: nil, force: :cascade do |t|
    t.text "token", null: false
    t.text "token_secret", null: false
    t.timestamptz "expires_at"
    t.integer "account_id", null: false
    t.integer "app_id"
    t.index ["account_id"], name: "socialaccount_socialtoken_account_id_951f210e"
    t.index ["app_id"], name: "socialaccount_socialtoken_app_id_636a42d7"
    t.unique_constraint ["app_id", "account_id"], name: "socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq"
  end

  add_foreign_key "account_emailaddress", "auth_user", column: "user_id", name: "account_emailaddress_user_id_2c513194_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "account_emailconfirmation", "account_emailaddress", column: "email_address_id", name: "account_emailconfirm_email_address_id_5b7f8c58_fk_account_e", deferrable: :deferred
  add_foreign_key "auth_group_permissions", "auth_group", column: "group_id", name: "auth_group_permissions_group_id_b120cbf9_fk_auth_group_id", deferrable: :deferred
  add_foreign_key "auth_group_permissions", "auth_permission", column: "permission_id", name: "auth_group_permissio_permission_id_84c5c92e_fk_auth_perm", deferrable: :deferred
  add_foreign_key "auth_permission", "django_content_type", column: "content_type_id", name: "auth_permission_content_type_id_2f476e4b_fk_django_co", deferrable: :deferred
  add_foreign_key "auth_user_groups", "auth_group", column: "group_id", name: "auth_user_groups_group_id_97559544_fk_auth_group_id", deferrable: :deferred
  add_foreign_key "auth_user_groups", "auth_user", column: "user_id", name: "auth_user_groups_user_id_6a12ed8b_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "auth_user_user_permissions", "auth_permission", column: "permission_id", name: "auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm", deferrable: :deferred
  add_foreign_key "auth_user_user_permissions", "auth_user", column: "user_id", name: "auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "django_admin_log", "auth_user", column: "user_id", name: "django_admin_log_user_id_c564eba6_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "django_admin_log", "django_content_type", column: "content_type_id", name: "django_admin_log_content_type_id_c4bce8eb_fk_django_co", deferrable: :deferred
  add_foreign_key "reviews_work", "reviews_author", column: "author_id", primary_key: "person_id", name: "reviews_work_author_id_2ff6ff3d_fk_reviews_author_person_id", deferrable: :deferred
  add_foreign_key "reviews_work", "reviews_author", column: "translator_id", primary_key: "person_id", name: "reviews_work_translator_id_a3674e09_fk_reviews_author_person_id", deferrable: :deferred
  add_foreign_key "socialaccount_socialaccount", "auth_user", column: "user_id", name: "socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "socialaccount_socialapp_sites", "django_site", column: "site_id", name: "socialaccount_social_site_id_2579dee5_fk_django_si", deferrable: :deferred
  add_foreign_key "socialaccount_socialapp_sites", "socialaccount_socialapp", column: "socialapp_id", name: "socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc", deferrable: :deferred
  add_foreign_key "socialaccount_socialtoken", "socialaccount_socialaccount", column: "account_id", name: "socialaccount_social_account_id_951f210e_fk_socialacc", deferrable: :deferred
  add_foreign_key "socialaccount_socialtoken", "socialaccount_socialapp", column: "app_id", name: "socialaccount_social_app_id_636a42d7_fk_socialacc", deferrable: :deferred
end
