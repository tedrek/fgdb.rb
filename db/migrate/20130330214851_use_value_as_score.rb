class UseValueAsScore < ActiveRecord::Migration
  def self.up
    add_column :pricing_components, :use_value_as_score, :boolean, :null => false, :default => false
  end

  def self.down
  end
end
