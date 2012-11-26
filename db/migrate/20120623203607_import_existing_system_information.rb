class ImportExistingSystemInformation < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false
    SpecSheet.find_in_batches(:conditions => ["id IN (SELECT DISTINCT ON(system_id) id FROM spec_sheets ORDER BY system_id, created_at DESC)"]) do |sheets|
      sheets.each do |sheet|
        sheet.set_extra_system_information(sheet.parser)
        sheet.save
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
  end
end
