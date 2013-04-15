class CleanupSpanishTypes < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      a = ContactType.find_by_name(:spanish_adoption)
      a.name = 'spanish_adoption'
      a.description = 'spanish adoption'
      a.save!

      b = ContactType.find_by_name(:spanish_build)
      b.name = 'spanish_build'
      b.description = 'spanish build'
      b.save!
    end
  end

  def self.down
  end
end
