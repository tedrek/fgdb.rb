class WorkShift < ActiveRecord::Base
  belongs_to :coverage_type
  belongs_to :job
  belongs_to :meeting
  belongs_to :schedule
  belongs_to :standard_shift
  belongs_to :weekday
  belongs_to :worker
  has_many :work_shifts

  def name
    ret = Job.find(:first, :conditions => "id = #{job_id}").name + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
  end

  def WorkShift::create_from_standard_shift( shift = StandardShift.new, date = Date.new )
    ret = WorkShift.new
    ret.shift_date = date
    ret.start_time = shift.start_time
    ret.end_time = shift.end_time
    ret.splitable = shift.splitable
    ret.mergeable = shift.mergeable
    ret.resizable = shift.resizable
    ret.worker_id = shift.worker_id
    #ret.coverage_type_id = shift.coverage_type_id
    ret.job_id = shift.job_id
    ret.meeting_id = shift.meeting_id
    ret.schedule_id = shift.schedule_id
    ret.standard_shift_id = shift.id
    ret.weekday_id = shift.weekday_id
    ret
  end

  def WorkShift::create_from_meeting( shift = Meeting.new, date = Date.new )
    ret = WorkShift.new
    ret.shift_date = date
    ret.start_time = shift.start_time
    ret.end_time = shift.end_time
    ret.splitable = shift.splitable
    ret.mergeable = shift.mergeable
    ret.resizable = shift.resizable
    ret.worker_id = shift.worker_id
    #ret.coverage_type_id = shift.coverage_type_id
    ret.meeting_id = shift.id
    ret.schedule_id = shift.schedule_id
    ret.weekday_id = shift.weekday_id
    ret
  end
end
