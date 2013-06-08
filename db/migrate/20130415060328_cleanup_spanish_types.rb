class CleanupSpanishTypes < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      a = ContactType.find_by_name(:spanish_adoption)
      if a
        a.name = 'spanish_adoption'
        a.description = 'spanish adoption'
        a.save!
      end

      b = ContactType.find_by_name(:spanish_build)
      if b
        b.name = 'spanish_build'
        b.description = 'spanish build'
        b.save!
      end
    end
  end

  def self.down
  end
end
