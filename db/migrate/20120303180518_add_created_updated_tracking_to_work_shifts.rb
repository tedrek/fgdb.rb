class AddCreatedUpdatedTrackingToWorkShifts < ActiveRecord::Migration
  def self.up
    for i in [:work_shifts, :shifts, :meetings, :unavailabilities, :vacations]
      add_column i, :created_by, :integer
      add_column i, :updated_by, :integer

      add_column i, :created_at, :datetime
      add_column i, :updated_at, :datetime

      add_foreign_key i, ["created_by"], "users", ["id"], :on_delete => :restrict
      add_foreign_key i, ["updated_by"], "users", ["id"], :on_delete => :restrict
    end
  end

  def self.down
  end
end
