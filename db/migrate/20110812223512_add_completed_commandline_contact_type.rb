class AddCompletedCommandlineContactType < ActiveRecord::Migration
  def self.up
    ct = ContactType.new
    ct.description = "completed commandline"
    ct.name = "completed_commandline"
    ct.for_who = "per"
    ct.instantiable = true
    ct.save
  end

  def self.down
  end
end
