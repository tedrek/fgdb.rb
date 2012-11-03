class CreatePricingDatas < ActiveRecord::Migration
  def self.up
    create_table :pricing_datas do |t|
      t.string :printme_pull_from
      t.string :printme_value
      t.string :lookup_type
      t.string :lookup_value

      t.timestamps
    end

    add_column :pricing_components, :lookup_type, :string
  end

  def self.down
    drop_table :pricing_datas
  end
end
