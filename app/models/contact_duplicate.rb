class ContactDuplicate < ActiveRecord::Base
  def self.list_dups()
    dups = self.connection.execute("
      SELECT dup_check, count(*)
      FROM contact_duplicates
      GROUP BY dup_check
      ORDER BY dup_check
    ")

    return dups.collect{|x|x}
  end
end
