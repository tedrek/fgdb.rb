class CreateCellPhones < ActiveRecord::Migration
  def self.up
    create_table :cell_phones do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :cell_phones
  end
end
