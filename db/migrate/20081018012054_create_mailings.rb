class CreateMailings < ActiveRecord::Migration
  def self.up
    create_table :mailings do |t|
      t.string     :name, :limit => 20
      t.string     :description, :limit => 100, :null => false
      t.integer    :created_by, :null => false
      t.integer    :updated_by
      t.timestamps
    end
    add_foreign_key :mailings, ["created_by"], :contacts, ["id"]
    add_foreign_key :mailings, ["updated_by"], :contacts, ["id"]
  end

  def self.down
    drop_table :mailings
  end
end
