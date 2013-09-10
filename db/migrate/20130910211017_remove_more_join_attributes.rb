class RemoveMoreJoinAttributes < ActiveRecord::Migration
  def self.up
    change_table :gizmo_contexts_gizmo_types do |t|
      t.remove :created_at, :updated_at, :lock_version
    end
  end

  def self.down
    change_table :gizmo_contexts_gizmo_types do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :lock_version, :null => false, :default => 0
    end
  end
end
