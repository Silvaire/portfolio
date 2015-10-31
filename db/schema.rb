# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150930115030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_IP"
    t.text     "content"
    t.string   "approved",       default: "pending"
    t.string   "agent"
    t.string   "typee"
    t.integer  "comment_parent"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["approved"], name: "index_comments_on_approved", using: :btree
  add_index "comments", ["comment_parent"], name: "index_comments_on_comment_parent", using: :btree
  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "custom_fields", force: :cascade do |t|
    t.string  "object_class"
    t.string  "name"
    t.string  "slug"
    t.integer "objectid"
    t.integer "parent_id"
    t.integer "field_order"
    t.integer "count",        default: 0
    t.boolean "is_repeat",    default: false
    t.text    "description"
    t.string  "status"
  end

  add_index "custom_fields", ["object_class"], name: "index_custom_fields_on_object_class", using: :btree
  add_index "custom_fields", ["objectid"], name: "index_custom_fields_on_objectid", using: :btree
  add_index "custom_fields", ["parent_id"], name: "index_custom_fields_on_parent_id", using: :btree
  add_index "custom_fields", ["slug"], name: "index_custom_fields_on_slug", using: :btree

  create_table "custom_fields_relationships", force: :cascade do |t|
    t.integer "objectid"
    t.integer "custom_field_id"
    t.integer "term_order"
    t.string  "object_class"
    t.text    "value"
    t.string  "custom_field_slug"
  end

  add_index "custom_fields_relationships", ["custom_field_id"], name: "index_custom_fields_relationships_on_custom_field_id", using: :btree
  add_index "custom_fields_relationships", ["custom_field_slug"], name: "index_custom_fields_relationships_on_custom_field_slug", using: :btree
  add_index "custom_fields_relationships", ["object_class"], name: "index_custom_fields_relationships_on_object_class", using: :btree
  add_index "custom_fields_relationships", ["objectid"], name: "index_custom_fields_relationships_on_objectid", using: :btree

  create_table "metas", force: :cascade do |t|
    t.string  "key"
    t.text    "value"
    t.integer "objectid"
    t.string  "object_class"
  end

  add_index "metas", ["key"], name: "index_metas_on_key", using: :btree
  add_index "metas", ["object_class"], name: "index_metas_on_object_class", using: :btree
  add_index "metas", ["objectid"], name: "index_metas_on_objectid", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "plugins_attacks", force: :cascade do |t|
    t.string   "path"
    t.string   "browser_key"
    t.integer  "site_id"
    t.datetime "created_at"
  end

  add_index "plugins_attacks", ["browser_key"], name: "index_plugins_attacks_on_browser_key", using: :btree
  add_index "plugins_attacks", ["path"], name: "index_plugins_attacks_on_path", using: :btree
  add_index "plugins_attacks", ["site_id"], name: "index_plugins_attacks_on_site_id", using: :btree

  create_table "plugins_contact_forms", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "count"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.text     "value"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "content_filtered"
    t.string   "status",           default: "published"
    t.datetime "published_at"
    t.integer  "post_parent"
    t.string   "visibility",       default: "public"
    t.text     "visibility_value"
    t.string   "post_class",       default: "Post"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "post_order",       default: 0
    t.integer  "taxonomy_id"
  end

  add_index "posts", ["post_class"], name: "index_posts_on_post_class", using: :btree
  add_index "posts", ["post_parent"], name: "index_posts_on_post_parent", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree
  add_index "posts", ["status"], name: "index_posts_on_status", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "term_relationships", force: :cascade do |t|
    t.integer "objectid"
    t.integer "term_order"
    t.integer "term_taxonomy_id"
  end

  add_index "term_relationships", ["objectid"], name: "index_term_relationships_on_objectid", using: :btree
  add_index "term_relationships", ["term_order"], name: "index_term_relationships_on_term_order", using: :btree
  add_index "term_relationships", ["term_taxonomy_id"], name: "index_term_relationships_on_term_taxonomy_id", using: :btree

  create_table "term_taxonomy", force: :cascade do |t|
    t.string   "taxonomy"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "count"
    t.string   "name"
    t.string   "slug"
    t.integer  "term_group"
    t.integer  "term_order"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "term_taxonomy", ["parent_id"], name: "index_term_taxonomy_on_parent_id", using: :btree
  add_index "term_taxonomy", ["slug"], name: "index_term_taxonomy_on_slug", using: :btree
  add_index "term_taxonomy", ["taxonomy"], name: "index_term_taxonomy_on_taxonomy", using: :btree
  add_index "term_taxonomy", ["term_order"], name: "index_term_taxonomy_on_term_order", using: :btree
  add_index "term_taxonomy", ["user_id"], name: "index_term_taxonomy_on_user_id", using: :btree

  create_table "user_relationships", force: :cascade do |t|
    t.integer "term_order"
    t.integer "active",           default: 1
    t.integer "term_taxonomy_id"
    t.integer "user_id"
  end

  add_index "user_relationships", ["term_taxonomy_id"], name: "index_user_relationships_on_term_taxonomy_id", using: :btree
  add_index "user_relationships", ["user_id"], name: "index_user_relationships_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "role",                   default: "client"
    t.string   "email"
    t.string   "slug"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.integer  "parent_id"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id",                default: -1
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["site_id"], name: "index_users_on_site_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
