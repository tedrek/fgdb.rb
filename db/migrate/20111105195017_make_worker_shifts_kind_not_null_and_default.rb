class MakeWorkerShiftsKindNotNullAndDefault < ActiveRecord::Migration
  def self.up
    change_column(:work_shifts, :kind, :string, :null => false, :default => 'StandardShift')
  end

  def self.down
  end
end
