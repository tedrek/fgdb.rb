class CreateSystemPricings < ActiveRecord::Migration
  def self.up
    create_table :system_pricings do |t|
      t.integer :system_id
      t.integer :spec_sheet_id
      t.integer :pricing_type_id
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :system_pricings
  end
end
