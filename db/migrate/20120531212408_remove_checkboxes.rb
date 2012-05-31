class RemoveCheckboxes < ActiveRecord::Migration
  def self.up
    for i in [:standard_shifts, :shifts, :work_shifts]
      remove_column i, :splitable
      remove_column i, :mergeable
      remove_column i, :resizable
    end
  end

  def self.down
  end
end
