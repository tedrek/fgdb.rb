class WorkShift < ActiveRecord::Base
  belongs_to :coverage_type
  belongs_to :job, :include => [:coverage_type]
  belongs_to :meeting
  belongs_to :schedule
  belongs_to :standard_shift
  belongs_to :weekday
  belongs_to :worker

  before_save :set_weekday_id

  def shift_date_display
    self.shift_date.strftime('%A, %B %d, %Y').gsub( ' 0', ' ' )
  end

  def display_name_skedj
    skedj = Thread.current['skedj_obj']
    raise if skedj.nil?
    prepend = ""
    if skedj.opts[:presentation_mode] == "Edit"
      prepend = "[#{self.id}] "
    end
    prepend + display_name
  end

  def display_name
    if self.kind == "Meeting"
      return self.meeting_name
    elsif self.kind == "Unavailability"
      return '(unavailable)'
    else
      return self.name
    end
  end

  def skedj_style(overlap, last)
    shift_style = ""
    if self.kind == 'Meeting'
      shift_style = 'meeting'
    elsif self.kind == 'Unavailability'
      shift_style = 'unavailable'
    elsif self.worker_id == 0
      shift_style = 'unfilled'
    elsif overlap
        # can't seem to get this part quite right
        # i expect a stupid syntax error
        # what should happen:
        # two overlapping anchored shifts should result 
        #   in hardconflict
        # two overlapping shifts where only one is anchored 
        #   should result in mediumconflict
        # other overlapping shifts should result in 
        #   softconflict
        # can't figure out if a shift is anchored?
        #   pretend it is anchored
        if (last.coverage_type ? last.coverage_type.name : 'anchored') == 'anchored'
          if not self.coverage_type
            shift_style = 'hardconflict'
          elsif self.coverage_type.name == 'anchored'
            shift_style = 'hardconflict'
          else
            shift_style = 'mediumconflict'
          end
        elsif self.coverage_type && self.coverage_type.name == 'anchored'
          shift_style = 'mediumconflict'
        else
          shift_style = 'softconflict'
        end
        # end of problem code
      else
        shift_style = self.training ? 'training' : 'shift'
      end
    return shift_style
  end


  def set_weekday_id
    self.weekday_id = self.shift_date.wday
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def name
    self.job.name + ' ' + time_range_s
  end

  def to_worked_shift
    ws = WorkedShift.new({:worker_id => self.worker_id, :duration => ((self.end_time - self.start_time) / 3600).to_f, :date_performed => self.shift_date})
    if self.kind == "Meeting"
      ws.job_id = Job.find_by_name("Meeting").id
    elsif self.kind == "StandardShift"
      ws.job_id = self.job_id
    else # Unavailability
      return nil
    end
    return ws
  end

  def WorkShift::create_from_shift( shift = Shift.new, date = Date.new )

    #logger.info 'xxx: in create_from_shift'
    ret = WorkShift.new
    ret.actual = true
    ret.kind = shift.type
    ret.start_time = shift.start_time
    ret.end_time = shift.end_time
    ret.splitable = shift.splitable
    ret.mergeable = shift.mergeable
    ret.resizable = shift.resizable
    ret.meeting_name = shift.meeting_name
    ret.shift_date = date
    ret.effective_date = shift.effective_date
    ret.ineffective_date = shift.ineffective_date
    ret.all_day = shift.all_day
    ret.repeats_every = shift.repeats_every
    ret.repeats_on = shift.repeats_on
    ret.coverage_type_id = shift.coverage_type_id
    ret.frequency_type_id = shift.frequency_type_id
    ret.job_id = shift.job_id
    ret.meeting_id = shift.meeting_id
    ret.schedule_id = shift.schedule_id
    ret.weekday_id = shift.weekday_id
    ret.worker_id = shift.worker_id
    ret
  end

  def WorkShift::create_from_standard_shift( shift = StandardShift.new, date = Date.new )
    logger.info 'xxx: in create_from_standard_shift'
    ret = WorkShift.new
    ret.actual = true
    ret.kind = 'StandardShift'
    ret.shift_date = date
    ret.start_time = shift.start_time
    ret.end_time = shift.end_time
    ret.splitable = shift.splitable
    ret.mergeable = shift.mergeable
    ret.resizable = shift.resizable
    ret.worker_id = shift.worker_id
    ret.training = shift.training
    #ret.coverage_type_id = shift.coverage_type_id
    ret.job_id = shift.job_id
    ret.schedule_id = shift.schedule_id
    #ret.standard_shift_id = shift.id
    ret.weekday_id = shift.weekday_id
    ret
  end

  def WorkShift::create_from_meeting( shift = Meeting.new, worker = Worker.new, date = Date.new )
    logger.info 'xxx: in create_from_meeting'
    ret = WorkShift.new
    ret.actual = true
    ret.kind = 'Meeting'
    ret.meeting_id = shift.id 
    ret.shift_date = date
    ret.start_time = shift.start_time
    ret.end_time = shift.end_time
    ret.effective_date = shift.effective_date
    ret.ineffective_date = shift.ineffective_date
    ret.splitable = shift.splitable
    ret.mergeable = shift.mergeable
    ret.resizable = shift.resizable
    ret.worker_id = worker.id
    #ret.coverage_type_id = shift.coverage_type_id
    ret.schedule_id = shift.schedule_id
    ret.weekday_id = shift.weekday_id
    ret.meeting_name = shift.meeting_name
    ret
  end

  def WorkShift::create_from_unavailability( shift = Unavailability.new, date = Date.new )
    logger.info 'xxx: in create_from_unavailability'
    ret = WorkShift.new
    ret.actual = true
    ret.kind = 'Unavailability'
    ret.shift_date = date
    ret.start_time = shift.start_time
    ret.end_time = shift.end_time
    ret.worker_id = shift.worker_id
    #ret.coverage_type_id = shift.coverage_type_id
    ret.weekday_id = shift.weekday_id
    ret
  end
end
