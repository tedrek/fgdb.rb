class AddCannotLogHoursForStaffFrontdeskJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :reason_cannot_log_hours, :string

    if Default.is_pdx
      j = Job.find_by_name("Front Desk")
      j.reason_cannot_log_hours = "Please track your hours using the Donor Desk and Volunteer Desk types."
      j.save!

      j = Job.new
      j.name = "Donor Desk"
      j.coverage_type = CoverageType.find_by_name("full")
      j.income_stream = IncomeStream.find_by_name("contributions")
      j.wc_category = WcCategory.find_by_name("8810 03")
      j.program = Program.find_by_name("fundraising")
      j.offsite = false
      j.virtual = false
      j.description = ""
      j.save!


      j = Job.new
      j.name = "Volunteer Desk"
      j.coverage_type = CoverageType.find_by_name("full")
      j.income_stream = IncomeStream.find_by_name("n/a")
      j.wc_category = WcCategory.find_by_name("8810 03")
      j.program = Program.find_by_name("volunteer")
      j.offsite = false
      j.virtual = false
      j.description = ""
      j.save!
    end
  end

  def self.down
  end
end
