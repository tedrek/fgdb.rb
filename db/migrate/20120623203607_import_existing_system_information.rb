class ImportExistingSystemInformation < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false
    count = 0
    sheets = SpecSheet.find(:all, :conditions => ["id IN (SELECT DISTINCT ON(system_id) id FROM spec_sheets ORDER BY system_id, created_at DESC)"])
    inc = (sheets.length / 100.0).to_i
    puts "Importing existing data:"
    sheets.each do |sheet|
      count += 1
      if (count % inc) == 0
        puts "#{count / sheets.length}% complete"
      end
      sheet.set_extra_system_information(sheet.parser)
      sheet.save
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
  end
end
