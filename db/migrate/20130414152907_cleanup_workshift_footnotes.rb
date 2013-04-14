class CleanupWorkshiftFootnotes < ActiveRecord::Migration
  def self.up
    WorkShiftFootnote.distinct('date').each{|x| a = WorkShiftFootnote.find_all_by_date(x).sort_by(&:updated_at); a.pop; a.each{|y| y.destroy!}}
  end

  def self.down
  end
end
