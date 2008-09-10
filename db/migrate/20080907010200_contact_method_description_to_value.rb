class ContactMethodDescriptionToValue < ActiveRecord::Migration
  def self.up
    rename_column :contact_methods, :description, :value
  end

  def self.down
    rename_column :contact_methods, :value, :description
  end
end
