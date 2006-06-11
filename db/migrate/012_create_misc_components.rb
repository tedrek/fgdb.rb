class CreateMiscComponents < ActiveRecord::Migration
  def self.up
    create_table :misc_components do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :misc_components
  end
end
