class AddBugCorrectionToSpecSheets < ActiveRecord::Migration
  def self.up
    add_column :systems, :bug_correction, :string
  end

  def self.down
    remove_column :systems, :bug_correction, :string
  end
end
