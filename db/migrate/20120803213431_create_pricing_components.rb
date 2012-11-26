class CreatePricingComponents < ActiveRecord::Migration
  def self.up
    create_table :pricing_components do |t|
      t.string :name
      t.string :pull_from
      t.boolean :numerical
      t.boolean :multiple

      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_components
  end
end
