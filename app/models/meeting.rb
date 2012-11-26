class Meeting < Shift
  has_many :standard_shifts
  has_many :work_shifts
  has_and_belongs_to_many :workers
  belongs_to :worker
  belongs_to :weekday
  belongs_to :schedule
  has_many :meeting_minders

  validates_presence_of :repeats_every_months

  named_scope :perpetual, :conditions => ['shift_date IS NULL']
  named_scope :generated, :conditions => ['schedule_id = ?', Schedule.generate_from.id]
  named_scope :effective_in_range, lambda { |start, fin|
    {:conditions => ["(((effective_date <= ? OR effective_date IS NULL) AND (ineffective_date > ? OR ineffective_date IS NULL)) OR (effective_date > ? AND ineffective_date <= ?) OR ((ineffective_date is NULL or ineffective_date > ?) AND (effective_date IS NULL or effective_date <= ?)))", start, start, start, fin, fin, fin]}
  }

  def last_meeting(today = nil)
    today ||= Date.today
    w = WorkShift.find(:first, :conditions => ['shift_id = ? AND shift_date < ?', self.id, today], :order => 'shift_date DESC')
    w ? w.shift_date : nil
  end

  def every_week?
    (self.week_1_of_month && self.week_2_of_month && self.week_3_of_month && self.week_4_of_month && self.week_5_of_month)
  end

  def name_part
    ret = meeting_name
    if self.job_id
      ret = ret + " [#{job.name}]"
    end
    ret
  end

  def name
    ret = name_part
    ret = ret + ' ' + start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")
    ret = ret.gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' )
    if ! every_week?
      ret = ret + " [weeks: #{(1..5).to_a.select{|n| self.send("week_#{n}_of_month")}.join(", ")}]"
    end
    if repeats_every_months != 1
      ret = ret + " [every #{repeats_every_months} months]"
    end
    ret
  end

  def generates_on_day?(day)
    #   check to see if its schedule prints this week
    #     (repeats_every and repeats_on), if not then
    #     skip
    n = (day.day/7.0).ceil
    self.schedule.which_week( day ) == self.schedule.repeats_on and ((not self.shift_date) or self.shift_date == day) and self.send("week_#{n}_of_month") and repeats_on_months == (_calculate_d(day) % repeats_every_months)
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
