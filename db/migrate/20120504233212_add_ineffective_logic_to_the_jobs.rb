class AddIneffectiveLogicToTheJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :effective_on, :date
    add_column :jobs, :ineffective_on, :date
  end

  def self.down
    remove_column :jobs, :effective_on
    remove_column :jobs, :ineffective_on
  end
end
