class CreatePowerSupplies < ActiveRecord::Migration
  def self.up
    create_table :power_supplies do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :power_supplies
  end
end
