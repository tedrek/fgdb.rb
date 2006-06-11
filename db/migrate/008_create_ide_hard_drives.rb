class CreateIdeHardDrives < ActiveRecord::Migration
  def self.up
    create_table :ide_hard_drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :ide_hard_drives
  end
end
