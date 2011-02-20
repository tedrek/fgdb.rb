class VolunteerShift < ActiveRecord::Base
#  validates_presence_of :volunteer_task_type_id
  validates_presence_of :roster_id
  validates_presence_of :slot_number
  validates_presence_of :end_time
  validates_presence_of :start_time

  belongs_to :volunteer_task_type
  has_many :assignments

  belongs_to :volunteer_event

  def skedj_style(overlap, last)
    overlap ? 'hardconflict' : 'shift'
  end

  def time_range_s
    (self.start_time("%I:%M") + ' - ' + self.end_time("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def start_time(format = "%H:%M")
    read_attribute(:start_time).strftime(format)
  end

  def self._parse_time(time)
    Time.mktime(2000, 01, 01, *time.split(":").map(&:to_i))
  end

  def start_time=(str)
    write_attribute(:start_time, VolunteerShift._parse_time(str))
  end

  def end_time(format = "%H:%M")
    read_attribute(:end_time).strftime(format)
  end

  def end_time=(str)
    write_attribute(:end_time, VolunteerShift._parse_time(str))
  end

  def fill_in_available
    Thread.current['volskedj_fillin_processing'] ||= []
    if Thread.current['volskedj_fillin_processing'].include?(self.id)
      return
    end
    begin
      Thread.current['volskedj_fillin_processing'].push(self.id)
      Assignment.find_all_by_volunteer_shift_id(self.id).select{|x| x.contact_id.nil?}.each{|x| x.destroy}
      inputs = [[time_to_int(self.read_attribute(:start_time)), time_to_int(self.read_attribute(:end_time))]]
      Assignment.find_all_by_volunteer_shift_id(self.id).select{|x| !x.cancelled?}.each{|x|
        inputs.push([time_to_int(x.start_time), time_to_int(x.end_time)])
      }
      results = range_math(*inputs)
      results = results.map{|a| a.map{|x| int_to_time(x)}}
      results.each{|x|
        a = Assignment.new
        a.volunteer_shift_id, a.start_time, a.end_time = self.id, x[0], x[1]
        a.save!
      }
    ensure
      Thread.current['volskedj_fillin_processing'].delete(self.id)
    end
  end

  after_save :fill_in_available

  def date
    self.volunteer_event.date
  end

  def date_display
    self.date.strftime('%A, %B %d, %Y').gsub( ' 0', ' ' )
  end

  def description_and_slot
    (self.volunteer_task_type_id * 1000) + self.slot_number
  end

  def weekday
    Weekday.find_by_id(self.date.strftime("%w"))
  end

  private

  # TODO: shift is 11 - 2
  #       assignment is 12-3 (over the end)
  # does not add an available for 11-12 as it should

#  fstart, pstart, fend, pend

  def range_math(*ranges)
    frange = nil
    ranges.each{|a|
      pstart, pend = a
      if frange.nil?
        frange = [[pstart, pend]]
      else
        frange.each{|a2|
          fstart, fend = a2
          if fstart < pstart and pstart < fend
            if pend >= fend
              fend = pstart
            else
              new = [pend, fend]
              frange.push(new)
              fend = pstart
            end
          elsif fstart >= pstart and fend <= pend
            fstart = fend = nil
          elsif pstart <= fstart and pend > fstart
            if pend > fend
              fstart = fend = nil # shouldn't get here
            else
              fstart = pend
            end
          end
          a2[0] = fstart
          a2[1] = fend
        }
        frange = frange.select{|x| !(x.first.nil? or x.first == x.last or x.last < x.first)}.sort_by{|x| x.first}
      end
    }
    return frange
  end

  def time_to_int(time)
    (time.hour * 60) + time.min
  end

  def int_to_time(int)
    hours = (int / 60).floor
    mins = int % 60
    Time.parse("#{hours}:#{mins}")
  end
end
