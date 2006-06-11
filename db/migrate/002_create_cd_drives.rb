class CreateCdDrives < ActiveRecord::Migration
  def self.up
    create_table :cd_drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :cd_drives
  end
end
