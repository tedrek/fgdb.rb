class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :table_name
      t.string :action
      t.integer :user_id
      t.integer :thing_id
      t.datetime :date
    end
  end

  def self.down
    drop_table :logs
  end
end
