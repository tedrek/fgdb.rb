class CreateNotations < ActiveRecord::Migration
  def self.up
    create_table :notations do |t|
      t.text :content
      t.references :contact, null: false
      t.integer :notatable_id
      t.string :notatable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :notations
  end
end
