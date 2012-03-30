class ClosedBooleanToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :closed, :boolean, :default => false, :null => false
    a = [91069, 92616]
    a.each do |d|
      c = Contact.find_by_id(d)
      if ! c
        puts "WARNING: Couldn't find no work contact ##{d}"
        next
      end
      DB.exec("UPDATE assignments SET contact_id = NULL, closed = 't' WHERE contact_id = #{c.id};")
      puts "Removing fake contact #{c.display_name}.."
      c.destroy
    end
  end

  def self.down
    remove_column :assignments, :closed
  end
end
