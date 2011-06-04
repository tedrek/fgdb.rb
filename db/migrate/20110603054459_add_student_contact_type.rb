class AddStudentContactType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      ct = ContactType.new
      ct.name = "student"
      ct.description = "student"
      ct.instantiable = true
      ct.for_who = "per"
      ct.save!
    end
  end

  def self.down
  end
end
