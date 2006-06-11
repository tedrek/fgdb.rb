class CreateMiscDrives < ActiveRecord::Migration
  def self.up
    create_table :misc_drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :misc_drives
  end
end
