class CreateStereos < ActiveRecord::Migration
  def self.up
    create_table :stereos do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :stereos
  end
end
