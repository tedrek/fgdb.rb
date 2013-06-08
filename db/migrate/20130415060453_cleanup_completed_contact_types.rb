class CleanupCompletedContactTypes < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      h = ContactType.find_by_name('completed_hardware_id')
      h.description = 'completed hardware id'
      h.save!

      s = ContactType.find_by_name('completed_system_eval')
      s.description = 'completed system eval'
      s.save!
    end
  end

  def self.down
  end
end
