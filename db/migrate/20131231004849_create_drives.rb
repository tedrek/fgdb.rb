class CreateDrives < ActiveRecord::Migration
  def self.up
    create_table :drives do |t|
      t.string      :manufacturer,           :limit => 100,     :null => false
      t.string      :model,                  :limit => 100,     :null => false
      t.string      :serial,                 :limit => 100,     :null => false
      t.integer     :size,                   :limit => 8,       :null => false
      t.date        :manufacture_date
      t.string      :firmware_version
      t.string      :physical_form_factor
      t.string      :interface_type
      t.string      :disk_label
      t.string      :board
      t.string      :board_status
      t.timestamps
    end
  end

  def self.down
    drop_table :drives
  end
end
