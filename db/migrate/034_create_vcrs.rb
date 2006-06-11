class CreateVcrs < ActiveRecord::Migration
  def self.up
    create_table :vcrs do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :vcrs
  end
end
