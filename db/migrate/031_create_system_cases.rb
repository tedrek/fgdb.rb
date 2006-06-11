class CreateSystemCases < ActiveRecord::Migration
  def self.up
    create_table :system_cases do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :system_cases
  end
end
