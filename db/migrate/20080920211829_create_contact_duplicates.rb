class CreateContactDuplicates < ActiveRecord::Migration
  def self.up
    create_table :contact_duplicates, :force => true do |t|
      t.integer :contact_id,       :unique => true, :null => false
      t.text    :dup_check,        :null => false
    end
    add_index :contact_duplicates, ["contact_id"]
    add_index :contact_duplicates, ["dup_check"]
    add_foreign_key :contact_duplicates, ["contact_id"], :contacts, ["id"]
  end

  def self.down
    drop_table :contact_duplicates
  end
end
