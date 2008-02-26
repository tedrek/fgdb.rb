class RevisionsAndTrash < ActiveRecord::Migration

  def self.up
    create_table :revision_records do |t|
      t.column :revisionable_type, :string, :limit => 100
      t.column :revisionable_id, :bigint
      t.column :revision, :integer
      t.column :data, :binary #, :limit => 5.megabytes
      t.column :created_at, :timestamp
    end
    create_table :trash_records do |t|
      t.column :trashable_type, :string
      t.column :trashable_id, :bigint
      t.column :data, :binary #, :limit => 5.megabytes
      t.column :created_at, :timestamp
    end

    add_index :revision_records, [:revisionable_type, :revisionable_id, :revision], :name => :revisionable, :unique => true
    add_index :trash_records, [:trashable_type, :trashable_id]
    add_index :trash_records, [:created_at, :trashable_type]
  end

  def self.down
    drop_table :revision_records
    drop_table :trash_records
  end

end
