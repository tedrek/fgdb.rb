class CreateDrives < ActiveRecord::Migration
  def self.up
    create_table :drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :drives
  end
end
