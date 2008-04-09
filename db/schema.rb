# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "contacts", :force => true do |t|
    t.boolean  "is_organization",                  :default => false
    t.string   "sort_name",         :limit => 25
    t.string   "first_name",        :limit => 25
    t.string   "middle_name",       :limit => 25
    t.string   "surname",           :limit => 50
    t.string   "organization",      :limit => 100
    t.string   "extra_address",     :limit => 52
    t.string   "address",           :limit => 52
    t.string   "city",              :limit => 30
    t.string   "state_or_province", :limit => 15
    t.string   "postal_code",       :limit => 25
    t.string   "country",           :limit => 100
    t.text     "notes"
    t.integer  "lock_version",                     :default => 0,     :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "created_by",                       :default => 1,     :null => false
    t.integer  "updated_by",                       :default => 1,     :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "system_id"
    t.integer  "contact_id"
    t.integer  "role_id"
    t.text     "lshw_output"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "created_by",   :default => 1, :null => false
    t.integer  "updated_by",   :default => 1, :null => false
    t.integer  "old_id"
    t.text     "notes"
    t.integer  "type_id"
    t.string   "os"
  end

  add_index "reports", ["contact_id"], :name => "reports_contact_id_index"
  add_index "reports", ["role_id"], :name => "reports_role_id_index"
  add_index "reports", ["system_id"], :name => "reports_system_id_index"
  add_index "reports", ["type_id"], :name => "reports_type_id_index"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "created_by",   :default => 1, :null => false
    t.integer  "updated_by",   :default => 1, :null => false
  end

  add_index "roles", ["name"], :name => "roles_name_index"

  create_table "systems", :force => true do |t|
    t.string   "system_vendor"
    t.string   "system_model"
    t.string   "system_serial_number"
    t.integer  "lock_version",         :default => 0, :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "created_by",           :default => 1, :null => false
    t.integer  "updated_by",           :default => 1, :null => false
    t.string   "mobo_vendor"
    t.string   "mobo_model"
    t.string   "mobo_serial_number"
    t.string   "serial_number"
    t.string   "vendor"
    t.string   "model"
  end

  add_index "systems", ["system_model"], :name => "systems_model_index"
  add_index "systems", ["system_serial_number"], :name => "systems_serial_number_index"
  add_index "systems", ["system_vendor"], :name => "systems_vendor_index"

  create_table "types", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "created_by",   :default => 1, :null => false
    t.integer  "updated_by",   :default => 1, :null => false
  end

  add_index "types", ["name"], :name => "types_name_index"

end
