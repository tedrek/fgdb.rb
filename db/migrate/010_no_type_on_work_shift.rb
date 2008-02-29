class NoTypeOnWorkShift < ActiveRecord::Migration
  def self.up
    rename_column "work_shifts", :type, :kind
  end

  def self.down
    rename_column "work_shifts", :kind, :type
  end
end
