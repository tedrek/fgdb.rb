class Initial < ActiveRecord::Migration
  def self.up
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
      t.integer  "lock_version",                :default => 0, :null => false
      t.datetime "updated_at"
      t.datetime "created_at"
      t.integer  "created_by",                  :default => 1, :null => false
      t.integer  "updated_by",                  :default => 1, :null => false
      t.integer  "old_id"
      t.text     "notes"
      t.integer  "type_id"
      t.string   "os",           :limit => nil
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
      t.string   "system_vendor",        :limit => nil
      t.string   "system_model",         :limit => nil
      t.string   "system_serial_number", :limit => nil
      t.integer  "lock_version",                        :default => 0, :null => false
      t.datetime "updated_at"
      t.datetime "created_at"
      t.integer  "created_by",                          :default => 1, :null => false
      t.integer  "updated_by",                          :default => 1, :null => false
      t.string   "mobo_vendor",          :limit => nil
      t.string   "mobo_model",           :limit => nil
      t.string   "mobo_serial_number",   :limit => nil
      t.string   "serial_number",        :limit => nil
      t.string   "vendor",               :limit => nil
      t.string   "model",                :limit => nil
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
  def self.down
    drop_table "types"
    drop_table "reports"
    drop_table "contacts"
    drop_table "systems"
    drop_table "roles"
  end
end
