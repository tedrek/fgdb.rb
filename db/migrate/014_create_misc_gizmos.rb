class CreateMiscGizmos < ActiveRecord::Migration
  def self.up
    create_table :misc_gizmos do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :misc_gizmos
  end
end
