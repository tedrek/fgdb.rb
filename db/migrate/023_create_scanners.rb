class CreateScanners < ActiveRecord::Migration
  def self.up
    create_table :scanners do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :scanners
  end
end
