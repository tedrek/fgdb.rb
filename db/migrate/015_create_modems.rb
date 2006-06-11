class CreateModems < ActiveRecord::Migration
  def self.up
    create_table :modems do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :modems
  end
end
