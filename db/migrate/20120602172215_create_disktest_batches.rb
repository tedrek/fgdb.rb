class CreateDisktestBatches < ActiveRecord::Migration
  def self.up
    create_table :disktest_batches do |t|
      t.integer :contact_id, :null => false
      t.string :name, :null => false
      t.date :date, :null => false
      t.date :finalized_on

      t.timestamps
    end

    add_foreign_key :disktest_batches, :contact_id, :contacts, :id, :on_delete => :restrict
  end

  def self.down
    drop_table :disktest_batches
  end
end
