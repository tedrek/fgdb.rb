class CreateUpses < ActiveRecord::Migration
  def self.up
    create_table :upses do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :upses
  end
end
