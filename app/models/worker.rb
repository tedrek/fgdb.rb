class Worker < ActiveRecord::Base
  has_many :standard_shifts
  has_and_belongs_to_many :jobs
  belongs_to :worker_type
  has_and_belongs_to_many :meetings
  has_many :work_shifts
  has_many :vacations
  belongs_to :contact
  validates_existence_of :contact, :allow_nil => false

  def is_available?( shift = Workshift.new )
    true
  end

  def effective_now?
    date = DateTime.now
    (effective_date.nil? || effective_date <= date) && (ineffective_date.nil? || ineffective_date > date)
  end

  def Worker.effective_in_range(p)
    Worker.find(:all, :conditions => ['(effective_date IS NULL OR effective_date < ?) AND (ineffective_date IS NULL OR ineffective_date > ?)', p.end_date, p.start_date]).sort_by(&:sort_by)
  end

  def sort_by
    self.contact ? (self.contact.surname + ", " + self.contact.first_name) : self.id.to_s
  end

  def to_payroll_hash(pay_period)
    h = {}
    h[:name] = self.sort_by
    h[:type] = self.worker_type.name
    total_logged = HoursCalendar.new(pay_period.start_date, pay_period.end_date)
    total_logged.fill_in_workers_hours(self)
    h[:hours] = total_logged.total
    holidays = HoursCalendar.new(pay_period.start_date, pay_period.end_date)
    holidays.add_in_holidays(self)
    h[:holiday] = holidays.total
    expected = HoursCalendar.new(pay_period.start_date, pay_period.end_date)
    expected.fill_in_workers_maximums(self)
    minimum = expected.total * self.floor_ratio
    h[:pto] = [0.0, minimum - (h[:hours] + h[:holiday])].max
    h[:overtime] = 0.0
    (pay_period.start_date..pay_period.end_date).to_a.select{|x| x.wday == 0}.each{|x|
      week = HoursCalendar.for_week_of(x)
      week.fill_in_workers_hours(self)
      week.add_in_holidays(self)
      h[:overtime] += [0.0, week.total - self.ceiling_hours].max
    }
    return h
  end

  def shifts_for_day(date)
    logged = logged_shifts_for_day(date)
    return [true, logged].flatten if logged.length > 0
    return [false, scheduled_shifts_for_day(date)].flatten
  end

  def scheduled_shifts_for_day(date)
    shifts = WorkShift.find(:all, :conditions => ['shift_date = ? AND worker_id = ?', date, self.id])
    shifts = shifts.map{|x| x.to_worked_shift}.delete_if{|x| x == nil}
    return shifts
  end

  def logged_shifts_for_day(date)
    return WorkedShift.find(:all, :conditions => ['date_performed = ? AND worker_id = ?', date, self.id])
  end

  def hours_worked_on_day(date)
    logged_shifts_for_day(date).inject(0.0){|t,x| t += x.duration}
  end

  def fill_in_for_calendar(calendar)
    calendar.set_missing_dates{|x| v = self.hours_worked_on_day(x)}
  end

  def fill_in_maximum_for_calendar(calendar)
    calendar.set_missing_dates{|x| v = self.maximum_on_day(x)}
  end

  def hours_scheduled_for_weekday(date)
    self.send(date.strftime("%A").downcase.to_sym)
  end

  def maximum_on_day(day)
    self.send(day.strftime("%A").downcase.to_sym).to_f
  end

  def holiday_credit_per_day
    salaried ? (ceiling_hours / 5.0) : 0.0
  end

  def floor_ratio
    floor_hours / ceiling_hours
  end

  def total_hours
    (0..6).map{|x| Date.strptime(x.to_s, "%w").strftime("%A").downcase}.inject(0.0){|t,x| t += self.send(x.to_sym).to_f}
  end
end
