class AddBoardWorkVolunteerTaskType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      v = VolunteerTaskType.new
      v.description = "board work"
      v.hours_multiplier = 1.0
      v.instantiable = true
      v.name = 'board'
      v.program = Program.find_by_name('mixed')
      v.save!
    end
  end

  def self.down
  end
end
