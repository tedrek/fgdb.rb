class CreateLaptops < ActiveRecord::Migration
  def self.up
    create_table :laptops do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :laptops
  end
end
