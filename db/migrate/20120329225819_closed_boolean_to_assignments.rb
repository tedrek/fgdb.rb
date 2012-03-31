class ClosedBooleanToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :closed, :boolean, :default => false, :null => false
    add_column :default_assignments, :closed, :boolean, :default => false, :null => false
    a = [91069, 92616]
    a.each do |d|
      c = Contact.find_by_id(d)
      if ! c
        puts "WARNING: Couldn't find no work contact ##{d}"
        next
      end
      pt = [PointsTrade.find_all_by_from_contact_id(c.id), PointsTrade.find_all_by_to_contact_id(c.id)].flatten
      pt.each{|x|
        x.destroy
      }
      DB.exec("UPDATE assignments SET contact_id = NULL, closed = 't' WHERE contact_id = #{c.id};")
      DB.exec("UPDATE default_assignments SET contact_id = NULL, closed = 't' WHERE contact_id = #{c.id};")
      puts "Removing fake contact #{c.display_name}.."
      c.destroy
    end
  end

  def self.down
    remove_column :assignments, :closed
    remove_column :default_assignments, :closed
  end
end
