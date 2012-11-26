class ReplaceCoverageTypes < ActiveRecord::Migration
  def self.up
    add_column :jobs, :fully_covered, :boolean, :null => false, :default => false
    ct = CoverageType.find_by_name("full")
    Job.find_all_by_coverage_type_id(ct.id).each do |x|
      x.fully_covered = true
      x.save!
    end
    for i in [:jobs, :shifts, :standard_shifts, :work_shifts] do
      remove_column i, :coverage_type_id
    end
    drop_table :coverage_types
  end

  def self.down
  end
end
