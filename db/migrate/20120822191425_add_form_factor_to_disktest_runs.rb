class AddFormFactorToDisktestRuns < ActiveRecord::Migration
  def self.up
    add_column :disktest_runs, :form_factor, :string
  end

  def self.down
  end
end
