class SetSortName < ActiveRecord::Migration
  def self.up
    Contact.connection.execute("UPDATE contacts SET sort_name = get_sort_name(is_organization, first_name, middle_name, surname, organization);")
  end

  def self.down
  end
end
