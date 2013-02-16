class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :warranty_lengths, :effecitve_on, :effective_on
  end

  def self.down
  end
end
