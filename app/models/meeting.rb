class Meeting < Shift
  has_many :standard_shifts
  has_many :work_shifts
  has_and_belongs_to_many :workers
  belongs_to :worker
  belongs_to :weekday
  belongs_to :schedule
  belongs_to :coverage_type
  has_many :meeting_minders

  named_scope :effective_in_range, lambda { |start, fin|
    {:conditions => ["(((effective_date <= ? OR effective_date IS NULL) AND (ineffective_date > ? OR ineffective_date IS NULL)) OR (effective_date > ? AND ineffective_date <= ?) OR ((ineffective_date is NULL or ineffective_date > ?) AND (effective_date IS NULL or effective_date <= ?)))", start, start, start, fin, fin, fin]}
  }

  def name
    ret = meeting_name
    if self.job_id
      ret = ret + " [#{job.name}]"
    end
    ret = ret + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret = ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
    if ! (self.week_1_of_month && self.week_2_of_month && self.week_3_of_month && self.week_4_of_month && self.week_5_of_month)
      ret = ret + " [weeks: #{(1..5).to_a.select{|n| self.send("week_#{n}_of_month")}.join(", ")}]"
    end
    ret
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
        workshift.job_id = self.job_id
        # workshift.worker_id = w.id
        workshift.save
      end
    end
  end
end
