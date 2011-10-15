class AddSysevalCount < ActiveRecord::Migration
  def self.up
    add_column :contacts, :syseval_count, :integer, :null => false, :default => 0
    Contact.find_each{|c| count = c.update_syseval_count; if c.syseval_count != 0; c.save!; end}
  end

  def self.down
    remove_column :contacts, :syseval_count
  end
end
