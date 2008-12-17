class SomeMetadataChangesRichardMade < ActiveRecord::Migration
  def self.up
    # #573
    if !ContactType.find_by_name("nomail")
      ct = ContactType.new
      ct.name = "nomail"
      ct.description = "no mail"
      ct.save!
    end
    # #574
    for i in ["V        H 8\\", "VH\\"]
      if !Generic.find_by_value(i)
        g = Generic.new
        g.value = i
        g.save!
      end
    end
    # #547
    begin
      remove_table :backuptable
    rescue
    end
    # #579
    if !VolunteerTaskType.find_by_name('case management')
      vt = VolunteerTaskType.new
      vt.name = 'case management'
      vt.description = 'case management'
      vt.parent_id = 24
      vt.save!
    end
  end

  def self.down
  end
end
