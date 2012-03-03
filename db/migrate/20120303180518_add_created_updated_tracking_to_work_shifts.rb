class AddCreatedUpdatedTrackingToWorkShifts < ActiveRecord::Migration
  def self.up
    for i in [:work_shifts, :shifts, :vacations, :standard_shifts]
      add_column i, :created_by, :integer
      add_column i, :updated_by, :integer

      add_column i, :created_at, :datetime
      add_column i, :updated_at, :datetime

      add_foreign_key i, ["created_by"], "users", ["id"], :on_delete => :restrict
      add_foreign_key i, ["updated_by"], "users", ["id"], :on_delete => :restrict
    end
  end

  def self.down
    for i in [:work_shifts, :shifts, :meetings, :unavailabilities, :vacations]
      remove_column i, :created_by
      remove_column i, :updated_by

      remove_column i, :created_at
      remove_column i, :updated_at
    end
  end
end
