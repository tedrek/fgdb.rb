class AddCheckName < ActiveRecord::Migration
  def self.up
    change_table :checks do |t|
      t.string :check_name
    end
  end

  def self.down
    change_table :checks do |t|
      t.remove :check_name
    end
  end
end
