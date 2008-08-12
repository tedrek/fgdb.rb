class AddInstantiableFieldToContactTypes < ActiveRecord::Migration
  def self.up
    add_column "contact_types", "instantiable", :boolean, :default => true, :null => false
  end

  def self.down
    remove_column "contact_types", "instantiable"
  end
end
