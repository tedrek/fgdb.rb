class VoltaskForFacilities < ActiveRecord::Migration
  def self.up
    vtt = VolunteerTaskType.new
    vtt.description = "facilities"
    vtt.hours_multiplier = 1
    vtt.instantiable = true
    vtt.name = "facilities"
    vtt.program = Program.find_by_name('mixed')
    vtt.save!
  end

  def self.down
  end
end
