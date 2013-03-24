class AddNameForPricingData < ActiveRecord::Migration
  def self.up
    rename_column :pricing_datas, :printme_pull_from, :table_name
    rename_column :pricing_components, :lookup_type, :lookup_column
    add_column :pricing_components, :lookup_table, :string
    DB.exec("UPDATE pricing_components SET lookup_table = lookup_column WHERE lookup_column IS NOT NULL AND lookup_column <> '';")
  end

  def self.down
  end
end
