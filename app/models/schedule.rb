class Schedule < ActiveRecord::Base
  has_many :standard_shifts
  has_many :holidays
  has_many :meetings
  has_many :work_shifts
  has_many :shift_footnotes

# find( :first, :conditions => ["? BETWEEN effective_date AND ineffective_date AND parent_id IS NULL", day] )
  def self.generate_from
    find_by_generate_from(true)
  end

  def self.reference_from
    find_by_reference_from(true)
  end

  def copy(newname)
    newsched = self.clone
    newsched.name = newname
    newsched.generate_from = false
    newsched.reference_from = false
    newsched.save!
    self.standard_shifts.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    self.meetings.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    self.holidays.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    self.shift_footnotes.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    return newsched
  end

  def which_week( date = Date.today.to_date )
    if self.repeats_every > 1
      long_time_ago = Date.new(1901, 12, 22)
      difference = (date - long_time_ago).to_int
      ((difference / 7) % self.repeats_every )
    else
      0
    end
  end

  def shows_on?( date = Date.today.to_date )
    # not sure if this works
    ret = true
    if self.repeats_every > 1
      long_time_ago = Date.new(1901, 12, 22)
      difference = (date - long_time_ago).to_int
      mod = ((difference / 7) % self.repeats_every )
      if mod != self.repeats_on
        ret = false
      end 
    end
    ret
  end

  def in_clause
    # returns a sql ready string in parens, a comma delimited list of ids
    # such as "(50)"
    ret = '('
    ret += self.id.to_s
    ret += ')'
  end

  def full_name
    ret = self.name
  end

  def date_range
    start_date = Date.new(1972, 11, 7)
    end_date = Date.new(1973, 2, 2)
    (start_date..end_date)
  end
end
