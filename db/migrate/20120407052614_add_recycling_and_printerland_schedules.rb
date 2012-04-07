class AddRecyclingAndPrinterlandSchedules < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      s = Sked.new(:category_type => "Area", :name => "Printerland")
      s.save
      s.rosters = [Roster.find_by_name('Printerland Interns'), Roster.find_by_name('Printerland')].select{|x| !x.nil?}
      s.save
      s = Sked.new(:category_type => "Area", :name => "Recycling")
      s.save
      s.rosters = [Roster.find_by_name('Recycling Interns'), Roster.find_by_name('Recycling')].select{|x| !x.nil?}
      s.save
    end
  end

  def self.down
  end
end
