#to load the data from the fgss database to the fgdb database:
#pg_dump --data-only --exclude-table=contacts fgss_development | sed 's/roles/actions/' | sed 's/reports/spec_sheets/' | psql fgdb_development

class AddFgssIntoFgdb < ActiveRecord::Migration
  def self.up
    create_table "actions", :force => true do |t|
      t.string   "name"
      t.integer  "lock_version", :default => 0, :null => false
      t.datetime "updated_at"
      t.datetime "created_at"
      t.integer  "created_by",   :default => 1, :null => false
      t.integer  "updated_by",   :default => 1, :null => false
    end
    
    add_index "actions", ["name"], :name => "roles_name_index"
        
    create_table "spec_sheets", :force => true do |t|
      t.integer  "system_id"
      t.integer  "contact_id"
      t.integer  "action_id"
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
      t.boolean  "flag"
    end
    
    add_index "spec_sheets", ["contact_id"], :name => "reports_contact_id_index"
    add_index "spec_sheets", ["action_id"], :name => "reports_role_id_index"
    add_index "spec_sheets", ["system_id"], :name => "reports_system_id_index"
    add_index "spec_sheets", ["type_id"], :name => "reports_type_id_index"
    
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
    drop_table "actions"
    drop_table "systems"
    drop_table "spec_sheets"
    drop_table "types"
  end
end
