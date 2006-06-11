class CreateNetworkingDevices < ActiveRecord::Migration
  def self.up
    create_table :networking_devices do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :networking_devices
  end
end
