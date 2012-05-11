class AddBirthdaysToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :birthday, :date
    if Default.is_pdx
      Default['minimum_volunteer_age'] = 16
    end
  end

  def self.down
    remove_column :contacts, :birthday
  end
end
