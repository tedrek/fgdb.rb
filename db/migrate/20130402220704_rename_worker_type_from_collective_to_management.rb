class RenameWorkerTypeFromCollectiveToManagement < ActiveRecord::Migration
  def self.up
    wt = WorkerType.find_by_name('collective')
    if Default.is_pdx && wt
      wt.name = 'management'
      wt.save!
    end
  end

  def self.down
  end
end
