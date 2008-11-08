class AddInstantiableToContracts < ActiveRecord::Migration
  def self.up
    add_column "contracts", "instantiable", :boolean, :default => true,  :null => false
  end

  def self.down
    remove_column "contracts", "instantiable"
  end
end
