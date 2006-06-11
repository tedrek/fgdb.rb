class CreateTapeDrives < ActiveRecord::Migration
  def self.up
    create_table :tape_drives do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :tape_drives
  end
end
