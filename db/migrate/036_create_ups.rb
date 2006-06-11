class CreateUps < ActiveRecord::Migration
  def self.up
    create_table :ups do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :ups
  end
end
