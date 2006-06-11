class CreateFloppyDrives < ActiveRecord::Migration
  def self.up
    create_table :floppy_drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :floppy_drives
  end
end
