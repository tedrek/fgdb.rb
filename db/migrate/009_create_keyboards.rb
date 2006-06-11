class CreateKeyboards < ActiveRecord::Migration
  def self.up
    create_table :keyboards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :keyboards
  end
end
