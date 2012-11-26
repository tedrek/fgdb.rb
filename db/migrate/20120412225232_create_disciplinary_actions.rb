class CreateDisciplinaryActions < ActiveRecord::Migration
  def self.up
    create_table :disciplinary_actions do |t|
      t.text :notes
      t.integer :contact_id, :null => false
      t.boolean :disabled, :default => false, :null => false

      t.timestamps
    end

    add_foreign_key :disciplinary_actions, :contact_id, :contacts, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :disciplinary_actions
  end
end
