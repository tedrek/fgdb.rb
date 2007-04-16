class DefaultsTable < ActiveRecord::Migration
  def self.up
    create_table "defaults", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "value", :string, :limit => 100
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end
  end

  def self.down
    drop_table "defaults"
  end
end
