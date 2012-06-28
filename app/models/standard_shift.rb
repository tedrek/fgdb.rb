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
    ret = self.job.name  + (offsite ? ' (Offsite)' : '') + (training ? ' (Training)' : '') + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
  end

  def skedj_style(overlap, last)
    shift_style = self.proposed ? 'proposed' : self.training ? 'training' : 'shift'
  end

  def skedjul_link_controller
    "shifts"
  end

  def generates_on_day?(day)
    # check schedule for repeats_every / repeats_on logic
    ((not self.shift_date) or self.shift_date == day) and self.schedule.which_week( day ) == self.schedule.repeats_on
  end

  def do_my_generate(day)
    # standard shifts always get saved (even if the worker can't work)
    # create a new work_shift from the date and standard_shift
    workshift = WorkShift.create_from_standard_shift( self, day )
    workshift.shift_id = self.id
    if workshift
      w = self.worker
      if !save_for_worker?(day)
        # check to see if worker's vacation overlaps with
        #   this shift, if so then set worker_id to 0
        workshift.worker = Worker.zero 
      end
      if workshift.worker and  [nil, WorkerType.find_by_name("inactive")].include?(workshift.worker.worker_type_on_day(day))
        # check to see if worker is no longer working 
        #   (or hasn't started yet)
        #   if so then set worker_id to 0
        workshift.worker = Worker.zero 
      end
      if not w.is_available? workshift 
        # check to see if worker is available for this shift,
        #   if not then set worker_id to 0
        workshift.worker = Worker.zero 
      end
      workshift.save
    end
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
