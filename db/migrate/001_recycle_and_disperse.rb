class RecycleAndDisperse < ActiveRecord::Migration
  def self.up
    create_table "dispersement_types", :force => true do |t|
      t.column "description", :string, :limit => 100
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end

    create_table "dispersements", :force => true do |t|
      t.column "comments", :text
      t.column "contact_id", :integer, :null => false
      t.foreign_key( "contact_id", :contacts, :id,
                     :on_delete => :set_null, :on_update => :cascade )
      t.column "dispersement_type_id", :integer, :null => false
      t.foreign_key( "dispersement_type_id", :dispersement_types, :id,
                     :on_delete => :set_null, :on_update => :cascade )
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end

    create_table "recyclings", :force => true do |t|
      t.column "comments", :text
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end

    rename_column "gizmo_events", "grant_id", "dispersement_id"
  end

  def self.down
    drop_table "dispersement_types"
    drop_table "dispersements"
    drop_table "recyclings"
    rename_column "gizmo_events", "dispersement_id", "grant_id"
  end
end
