class StandardShift < Shift
  belongs_to :coverage_type
  belongs_to :job, :include => [:coverage_type]
  belongs_to :weekday
  belongs_to :worker
  belongs_to :meeting
  belongs_to :schedule
  has_many :work_shifts

# breaks save, not sure why it was there in the first place, commit 7780205e
#  def self.table_name
#    "standard_shifts"
#  end

  def name
    ret = self.job.name + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
  end

  def skedj_style(overlap, last)
    return 'shift'
  end

  def skedjul_link_controller
    "shifts"
  end

  def long_name
    weekday = Weekday.find(:first, :conditions => "id = #{weekday_id}").short_name + ', ' 
    ret = weekday + Job.find(:first, :conditions => "id = #{job_id}").name + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
  end

  def job_name
    weekday = self.weekday.short_name + ', ' 
    ret = weekday + self.worker.name + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
  end

end
