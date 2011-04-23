class VolunteerEvent < ActiveRecord::Base
  validates_presence_of :date
  has_many :volunteer_shifts, :dependent => :destroy
  has_many :resources_volunteer_events, :dependent => :destroy

  def date_anchor
    self.date.strftime('%Y%m%d')
  end

  def time_range_s
    my_start_time = self.volunteer_shifts.sort_by(&:start_time).first.start_time
    my_end_time = self.volunteer_shifts.sort_by(&:end_time).last.end_time
    (my_start_time.strftime("%I:%M") + ' - ' + my_end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def merge_similar_shifts
      hash = {}
      self.volunteer_shifts.each{|y|
        k = (y.volunteer_task_type_id.to_s || "0") + "-" + (y.description || "")
        hash[k] ||= []
        hash[k] << y
      }
      hash.each{|k, v|
        prev_length = 0
        length = v.length
        while length != prev_length
          v.each{|first|
            v.each{|second|
              next if first.id == second.id
              combine = false
              if ((first.end_time == second.start_time) or (first.start_time == second.end_time)) and (first.slot_number == second.slot_number)
                first.start_time = [first.start_time, second.start_time].min
                first.end_time = [first.end_time, second.end_time].max
                combine = true
              end
              if combine
                first.assignments << second.assignments
                second.destroy
                v.delete(second)
                first.save!
                break
              end
            }
          }
          prev_length = length
          length = v.length
        end
      }
  end

  def copy_to(date, time_shift)
    new = self.class.new(self.attributes)
    new.volunteer_shifts = self.volunteer_shifts.map{|x| x.class.new(x.attributes)}
#    new.resources = self.resources.map{|x| x.class.new(x.attributes)}
    new.date = date
    new.volunteer_shifts.each{|x| x.time_shift(time_shift)}
#    new.resources.each{|x| x.time_shift(time_shift)}
    new.save!
    new.volunteer_shifts.each{|x| x.save!}
    return new
  end
end
