class CreateWorkShiftFootnotes < ActiveRecord::Migration
  def self.up
    create_table :work_shift_footnotes do |t|
      t.datetime :date
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :work_shift_footnotes
  end
end
