class CreateScsiHardDrives < ActiveRecord::Migration
  def self.up
    create_table :scsi_hard_drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :scsi_hard_drives
  end
end
