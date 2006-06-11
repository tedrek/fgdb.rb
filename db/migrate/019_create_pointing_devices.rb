class CreatePointingDevices < ActiveRecord::Migration
  def self.up
    create_table :pointing_devices do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :pointing_devices
  end
end
