class AddDefaultAssignmentsEffectiveIneffective < ActiveRecord::Migration
  def self.up
    remove_column :volunteer_default_shifts, :effective_at # oops, forgot?
    remove_column :volunteer_default_shifts, :ineffective_at # about these
    add_column :volunteer_default_shifts, :effective_on, :date
    add_column :volunteer_default_shifts, :ineffective_on, :date
  end

  def self.down
    remove_column :volunteer_default_shifts, :effective_on
    remove_column :volunteer_default_shifts, :ineffective_on
  end
end
