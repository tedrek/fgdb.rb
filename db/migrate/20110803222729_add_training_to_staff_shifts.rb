class AddTrainingToStaffShifts < ActiveRecord::Migration
  def self.up
    for i in [:work_shifts, :shifts]
      add_column i, :training, :boolean, :default => false
    end
  end

  def self.down
    for i in [:work_shifts, :shifts]
      remove_column i, :training
    end
  end
end
