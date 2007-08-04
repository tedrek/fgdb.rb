class RemoveRelationships < ActiveRecord::Migration
  def self.up
    drop_table :relationships
    drop_table :relationship_types
  end

  def self.down
    create_table "relationship_types" do |t|
      t.column "description", :string, :limit => 100
      t.column "direction_matters", :boolean
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end
    create_table "relationships", :force => true do |t|
      t.column "source_id", :integer
      t.column "sink_id", :integer
      t.column "flow", :integer
      t.column "relationship_type_id", :integer
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end
    add_foreign_key "relationships", ["relationship_type_id"], "relationship_types", ["id"], :on_delete => :set_null
    add_foreign_key "relationships", ["sink_id"], "contacts", ["id"], :on_delete => :set_null
    add_foreign_key "relationships", ["source_id"], "contacts", ["id"], :on_delete => :set_null
  end
end
