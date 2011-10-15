class RemoveCruftyContactTypes < ActiveRecord::Migration
  def self.up
    for i in ["certified", "waiting", "comp4kids", "member", "preferemail"]
      ct = ContactType.find_by_name(i)
      ct.destroy if ct
    end
  end

  def self.down
  end
end
