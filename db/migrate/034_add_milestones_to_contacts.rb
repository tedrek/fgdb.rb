class AddMilestonesToContacts < ActiveRecord::Migration
  def self.up
    Contact.connection.execute("ALTER TABLE contacts ADD COLUMN next_milestone bigint DEFAULT 100")
    Contact.connection.execute("UPDATE contacts SET next_milestone=(SELECT (ceil((sum(duration)+1)/100)*100) FROM volunteer_tasks WHERE contact_id=contacts.id GROUP BY contact_id)")
    Contact.connection.execute("UPDATE contacts SET next_milestone=100 WHERE next_milestone IS NULL OR next_milestone < 100")
    if Default.find(:first, :conditions=>"name='my_email_address'").nil?()
      Default.connection.execute("INSERT INTO defaults(name, value) VALUES ('my_email_address', 'fgdb@freegeek.org')")
    end
    if Default.find(:first, :conditions=>"name='volunteer_reports_to'").nil?()
      Default.connection.execute("INSERT INTO defaults(name, value) VALUES ('volunteer_reports_to', 'volunteer@freegeek.org')")
    end
  end

  def self.down
    Contact.connection.execute("ALTER TABLE contacts DROP COLUMN next_milestone")
    x = Default.find(:first, :conditions=>"name='volunteer_reports_to'")
    unless x.nil?
      x.destroy()
    end
    x = Default.find(:first, :conditions=>"name='my_email_address'")
    unless x.nil?
      x.destroy()
    end
  end
end
