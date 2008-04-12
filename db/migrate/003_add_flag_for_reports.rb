class AddFlagForReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :flag, :boolean
  end

  def self.down
    remove_column :reports, :flag
  end
end
