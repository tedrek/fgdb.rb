class VolunteerShift < ActiveRecord::Base
  belongs_to :volunteer_task_type
  has_many :assignments

  @@processing = [] # this shit is gonna be buggy...but fill_in_available does lots of things which will trigger itself, and crazy shit would happen.
  # TODO: use Thread['processing'] instead of a class variable so this is thread safe and clears each request so there's no bugs from stale information

  def fill_in_available
    Thread.current['volskedj_fillin_processing'] ||= []
    if Thread.current['volskedj_fillin_processing'].include?(self.id)
      return
    end
    begin
      Thread.current['volskedj_fillin_processing'].push(self.id)
      Assignment.find_all_by_volunteer_shift_id(self.id).select{|x| x.contact_id.nil?}.each{|x| x.destroy}
      inputs = [[time_to_int(self.start_time), time_to_int(self.end_time)]]
      Assignment.find_all_by_volunteer_shift_id(self.id).each{|x|
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
