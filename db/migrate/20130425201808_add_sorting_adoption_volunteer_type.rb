class AddSortingAdoptionVolunteerType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      vt = VolunteerTaskType.find_by_name('sorting')
      if vt
        vt.name = 'hardware_id'
        vt.save!
      end

      vt = VolunteerTaskType.new
      vt.description = 'sorting'
      vt.hours_multiplier = 1.0
      vt.name = 'sorting'
      vt.program = Program.find_by_name('adoption')
      vt.adoption_credit = true
      vt.save!
    end
  end

  def self.down
    if Default.is_pdx
      vt = VolunteerTaskType.find_by_name('sorting')
      if vt
        vt.destroy
      end
    end
  end
end
