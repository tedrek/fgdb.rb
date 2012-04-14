class Meeting < Shift
  has_many :standard_shifts
  has_many :work_shifts
  has_and_belongs_to_many :workers
  belongs_to :worker
  belongs_to :weekday
  belongs_to :schedule
  belongs_to :frequency_type
  belongs_to :coverage_type

  def name
    ret = meeting_name + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
  end

  def generates_on_day?(day)
    #   check to see if its schedule prints this week
    #     (repeats_every and repeats_on), if not then
    #     skip
    n = (day.day/7.0).ceil
    self.schedule.which_week( day ) == self.schedule.repeats_on and ((not self.shift_date) or self.shift_date == day) and self.send("week_#{n}_of_month")
  end

  def do_my_generate(day)
    # get a list of all workers attending this
    # meeting and loop through it
    self.workers.each do |w|
      # if worker is on vacation, don't save shift
      if save_for_worker?(day, w)
        workshift = WorkShift.create_from_meeting( self, w, day )
        workshift.shift_id = self.id
        # workshift.worker_id = w.id
        workshift.save
      end
    end
  end
end
