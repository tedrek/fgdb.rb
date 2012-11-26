class AddPlugIntoPortlandVolunteerTask < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      v = VolunteerTaskType.new
      v.description = "plug into portland"
      v.hours_multiplier = 1.0
      v.instantiable = true
      v.name = 'plug_into_portland'
      v.program = Program.find_by_name('adoption')
      v.save!
    end
  end

  def self.down
  end
end
