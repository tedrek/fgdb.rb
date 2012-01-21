class AddBreakJob < ActiveRecord::Migration
  def self.up
    j = Job.new
    j.wc_category_id = 4
    j.coverage_type_id = 5
    j.virtual = false
    j.name = 'Paid Break'
    j.save!
  end

  def self.down
  end
end
