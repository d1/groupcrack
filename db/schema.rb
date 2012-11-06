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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121103181215) do

  create_table "organization_role_settings", :force => true do |t|
    t.integer "organization_role_id"
    t.integer "setting_type_id"
    t.integer "setting_value_id"
  end

  create_table "organization_roles", :force => true do |t|
    t.integer "organization_id"
    t.string  "name"
    t.integer "sign_up_role",    :default => 0
    t.integer "admin_role",      :default => 0
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "organizations", ["subdomain"], :name => "index_organizations_on_subdomain", :unique => true

  create_table "seed_files", :force => true do |t|
    t.string   "keyword"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "seed_files", ["keyword"], :name => "index_seed_files_on_keyword", :unique => true

  create_table "setting_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "keyword"
    t.string   "site_or_org_specific"
    t.integer  "user_specific",        :default => 0
    t.integer  "user_modifiable",      :default => 0
    t.integer  "locked",               :default => 0
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "setting_types", ["keyword"], :name => "index_setting_types_on_keyword", :unique => true
  add_index "setting_types", ["site_or_org_specific"], :name => "index_setting_types_on_site_or_org_specific"
  add_index "setting_types", ["user_modifiable"], :name => "index_setting_types_on_user_modifiable"

  create_table "setting_values", :force => true do |t|
    t.integer  "setting_type_id"
    t.string   "name"
    t.integer  "position",        :default => 0
    t.integer  "default_value",   :default => 0
    t.integer  "locked",          :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "keyword"
  end

  add_index "setting_values", ["default_value"], :name => "index_setting_values_on_default_value"
  add_index "setting_values", ["keyword"], :name => "index_setting_values_on_keyword"
  add_index "setting_values", ["setting_type_id"], :name => "index_setting_values_on_setting_type_id"

  create_table "settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "setting_type_id"
    t.integer  "setting_value_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "priority",         :default => 10
  end

  add_index "settings", ["organization_id"], :name => "index_settings_on_organization_id"
  add_index "settings", ["priority"], :name => "index_settings_on_priority"
  add_index "settings", ["setting_type_id"], :name => "index_settings_on_setting_type_id"
  add_index "settings", ["setting_value_id"], :name => "index_settings_on_setting_value_id"
  add_index "settings", ["user_id"], :name => "index_settings_on_user_id"

  create_table "user_memberships", :force => true do |t|
    t.integer "user_id"
    t.integer "organization_id"
    t.integer "organization_role_id"
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "first_name",             :default => "", :null => false
    t.string   "last_name",              :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
