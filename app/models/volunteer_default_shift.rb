class VolunteerDefaultShift < ActiveRecord::Base
  validates_presence_of :roster_id
  validates_presence_of :end_time
  validates_presence_of :start_time
  validates_presence_of :slot_count
  belongs_to :volunteer_task_type
  belongs_to :volunteer_default_event
  belongs_to :program
  belongs_to :roster

  has_many :default_assignments

#  named_scope :effective_at, lambda { |date|
#    { :conditions => ['(effective_at IS NULL OR effective_at <= ?) AND (ineffective_at IS NULL OR ineffective_at > ?)', date, date] }
#  }
  named_scope :on_weekday, lambda { |wday|
    { :conditions => ['weekday_id = ?', wday] }
  }

  def validate
    errors.add('slot_count', 'cannot be more than one for an intern shift') if self.not_numbered and self.slot_count and self.slot_count > 1
  end

  before_destroy :get_rid_of_available
  def get_rid_of_available
    Thread.current['volskedj2_fillin_processing'] ||= []
    if Thread.current['volskedj2_fillin_processing'].include?(self.id)
      return
    end
    begin
      Thread.current['volskedj2_fillin_processing'].push(self.id)

      a = self.default_assignments.select{|x| x.contact_id.nil?}
      a.each{|x| x.destroy}
      self.default_assignments = []

    ensure
      Thread.current['volskedj2_fillin_processing'].delete(self.id)
    end
  end

  def set_description
    self.description
  end

  def set_description=(desc)
    self.description=(desc)
  end

  def set_weekday_id=(val)
    @set_weekday_id_set = true
    @set_weekday_id = (val.nil? || val.blank?) ? nil : val.to_i
  end

  def set_weekday_id
    @set_weekday_id_set ?  @set_weekday_id : self.volunteer_default_event.weekday_id
  end

  def set_weekday_id_set
    @set_weekday_id_set
  end

  def weekday
    self.volunteer_default_event.weekday
  end

  def weekday_name
    weekday ? weekday.name : nil
  end

  def set_values_if_stuck
    return unless self.stuck_to_assignment
    assn = self.default_assignments.first
    return unless assn
    self.start_time = assn.start_time
    self.end_time = assn.end_time
    return unless self.volunteer_default_event_id.nil? or self.volunteer_default_event.description.match(/^Roster #/)
    return unless set_weekday_id_set
    roster = Roster.find_by_id(self.roster_id)
    if roster and !(set_weekday_id == nil || set_weekday_id == "")
      ve = roster.vol_event_for_weekday(set_weekday_id)
      ve.save! if ve.id.nil?
      self.volunteer_default_event = ve
      self.volunteer_default_event_id = ve.id
    else
      if self.volunteer_default_event.nil?
        self.volunteer_default_event = VolunteerDefaultEvent.new
      end
    end
  end

  def fill_in_available(slot_num = nil)
    return if self.stuck_to_assignment
    Thread.current['volskedj2_fillin_processing'] ||= []
    if Thread.current['volskedj2_fillin_processing'].include?(self.id)
      return
    end
    begin
      Thread.current['volskedj2_fillin_processing'].push(self.id)
      slots = slot_num ? [slot_num] : (1 .. self.slot_count).to_a
      slots = [nil] if self.not_numbered
      DefaultAssignment.find_all_by_volunteer_default_shift_id(self.id).select{|x| x.contact_id.nil? and !x.closed}.each{|x| x.destroy if slots.include?(x.slot_number)}
      inputs = {}
      inputs_always_nweek = {}
      inputs_always_lweek = {}
      inputs_always = {}
      for letter in ['a', 'b']
        for week in [1, 2, 3, 4, 5]
          inputs[[letter, week]] = {}
        end
        inputs_always_nweek[letter] = {}
      end
      for week in [1, 2, 3, 4, 5]
        inputs_always_lweek[week] = {}
      end
      full = [(self.read_attribute(:start_time)), (self.read_attribute(:end_time))]
      slots.each{|q|
        for letter in ['a', 'b']
          for week in [1, 2, 3, 4, 5]
            inputs[[letter, week]][q] = []
          end
          inputs_always_nweek[letter][q] = []
        end
        for week in [1, 2, 3, 4, 5]
          inputs_always_lweek[week][q] = []
        end
        inputs_always[q] = []
      }
      DefaultAssignment.find_all_by_volunteer_default_shift_id(self.id).each{|x|
        slot = x.slot_number
        if slots.include?(slot)
          list = [1, 2, 3, 4, 5].select{|n| x.send("week_#{n}_of_month")}
          letter = x.week.to_s.downcase.strip
          t = [(x.start_time), (x.end_time)]
          if letter == '' && list.length == 5
            inputs_always[slot].push(t)
            for week in [1, 2, 3, 4, 5]
              inputs_always_lweek[week][slot].push(t)
              for letter in ['a', 'b']
                inputs[[letter, week]][slot].push(t)
              end
            end
            for letter in ['a', 'b']
              inputs_always_nweek[letter][slot].push(t)
            end
          elsif list.length == 5
            inputs_always_nweek[letter][slot].push(t)
            for week in [1, 2, 3, 4, 5]
              inputs_always_lweek[week][slot].push(t)
              inputs[[letter, week]][slot].push(t)
            end
            inputs_always[slot].push(t)
          elsif letter == ''
            for letter in ['a', 'b']
              inputs_always_nweek[letter][slot].push(t)
            end
            list.each do |num|
              inputs_always_lweek[num][slot].push(t)
              for letter in ['a', 'b']
                inputs[[letter, num]][slot].push(t)
              end
            end
            inputs_always[slot].push(t)
          else
            inputs_always[slot].push(t)
            list.each do |week|
              inputs[[letter, week]][slot].push(t)
              inputs_always_lweek[week][slot].push(t)
            end
            inputs_always_nweek[letter][slot].push(t)
          end
        end
      }
      slots.each{|q|
        # inputs_always looks only at inputs_always
        # inputs_always_nweek looks at results_always and inputs_always_nweek
        # inputs_always_lweek looks at results_always and inputs_always_lweek
        # inputs looks at results_always, results_always_lweek, results_always_nweek
        results_always_nweek = {}
        results_always_lweek = {}
        results = {}
        results_always = self.class.range_math(full, *(inputs_always[q]))
        for letter in ['a', 'b']
          results_always_nweek[letter] = self.class.range_math(full, *(inputs_always_nweek[letter][q] + results_always))
        end
        for week in [1, 2, 3, 4, 5]
          results_always_lweek[week] = self.class.range_math(full, *(inputs_always_lweek[week][q] + results_always))
        end
        for letter in ['a', 'b']
          for week in [1, 2, 3, 4, 5]
            results[[letter, week]] = self.class.range_math(full, *(inputs[[letter, week]][q] + results_always + results_always_lweek[week] + results_always_nweek[letter]))
          end
        end
        list = [['', -1, results_always]]
        list << ['A', -1, results_always_nweek['a']]
        list << ['B', -1, results_always_nweek['b']]
        for week in [1, 2, 3, 4, 5]
          list << ['', week, results_always_lweek[week]]
          list << ['A', week, results[['a', week]]]
          list << ['B', week, results[['b', week]]]
        end
#          both_results = self.class.range_math(full, *both)
#          a_result = self.class.range_math(full, *(both_results + a))
#          b_result = self.class.range_math(full, *(both_results + b))
        list.each{|letter, week, results|
          results.each{|x|
            a = DefaultAssignment.new
            a.volunteer_default_shift_id, a.start_time, a.end_time = self.id, x[0], x[1]
            a.slot_number = q unless self.not_numbered
            a.week = letter
            list = ((week == -1) ? [] : ([1, 2, 3, 4, 5] - [week]))
            list.each {|n|
              a.send("week_#{n}_of_month=", false)
            }
            a.save!
          }
        }
      }
    ensure
      Thread.current['volskedj2_fillin_processing'].delete(self.id)
    end
  end

  def description_and_slot
    0
  end

  after_save :fill_in_available

  def skedj_style(overlap, last)
    'shift'
  end

  def describe
    s = slot_count.to_s + " slots from " + time_range_s
#    s += " assigned to #{self.default_assignment.contact.display_name}" if self.default_assignment
    s
  end

  def left_unique_value
    [self.volunteer_task_type_id.nil? ? self.volunteer_default_event.description : self.volunteer_task_type_id, self.description].join(", ")
  end

  def left_method_name
    a = [self.volunteer_task_type_id.nil? ? self.volunteer_default_event.description : volunteer_task_type.description]
    a << self.description if self.description.to_s.length > 0
    a.join(", ")
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def time_shift(val)
    self.start_time += val
    self.end_time += val
  end

  def VolunteerDefaultShift.find_conflicts(startd, endd, gconditions = nil)
    gconditions ||= Conditions.new
    vs_conds = gconditions.dup
    vs_conds.empty_enabled = "false"

    vs_conds.date_enabled = "true"
    vs_conds.date_date_type = 'arbitrary'
    vs_conds.date_start_date = startd.to_s
    vs_conds.date_end_date = endd.to_s

    matches = VolunteerShift.find(:all, :conditions => vs_conds.conditions(VolunteerShift), :include => [:volunteer_event])
  end

  def VolunteerDefaultShift.find_conflicting_assignments(start_date, end_date, gconditions = nil)
    ignore_these_shifts = VolunteerDefaultShift.find_conflicts(start_date, end_date, gconditions).map{|x| x.id}
    if gconditions
      gconditions = gconditions.dup
      gconditions.empty_enabled = "false"
    else
      gconditions = Conditions.new
    end
    ret_arr = []
    (start_date..end_date).map{|x|
      next if Holiday.is_holiday?(x)
      w = Weekday.find(x.wday)
      ds_conds = gconditions.dup
      ds_conds.effective_on_enabled = "true"
      ds_conds.effective_on_start = x
      ds_conds.effective_on_end = x + 1
      ds_conds.weekday_enabled = "true"
      ds_conds.weekday_id = w.id
      ds_conds.week_enabled = "true"
      ds_conds.week = VolunteerShift.week_for_date(x)
      VolunteerDefaultShift.find(:all, :order => "volunteer_default_shifts.roster_id, volunteer_default_shifts.description", :conditions => ds_conds.conditions(VolunteerDefaultShift), :include => [:volunteer_default_event]).map{|ds|
        ds.default_assignments
      }.flatten.select{|q| q.contact_id and (!q.contact.is_organization?)}.map{|da|
        a = Assignment.new
        a.start_time = da.start_time
        a.end_time = da.end_time
        a.contact_id = da.contact_id
        a.internal_date_hack_value = x
        [x.strftime('%Y%m%d'), da, a.find_overlappers(:for_contact).select{|aa| !ignore_these_shifts.include?(aa.volunteer_shift_id)}]
      }.each{|x|
        if x.last.length > 0 # da will have conflicts
          ret_arr << x
        end
      }
    }
    return ret_arr
  end

  def VolunteerDefaultShift.generate(start_date, end_date, gconditions = nil, skip_these = [])
    if gconditions
      gconditions = gconditions.dup
      gconditions.empty_enabled = "false"
    else
      gconditions = Conditions.new
    end
    string = gconditions.to_s
    string = "Everything" if string.length == 0
    Notifier.deliver_text_report('volskedj_reports_to', "Volunteer schedule rolled out for #{gconditions.to_s}", "Done for #{start_date} to #{end_date} by #{Thread.current['user'].to_s} at #{Time.now.strftime("%D %T")}.")
    (start_date..end_date).each{|x|
      next if Holiday.is_holiday?(x)
      w = Weekday.find(x.wday)
      #      next if !w.is_open
      ds_conds = gconditions.dup
      ds_conds.effective_on_enabled = "true"
      ds_conds.effective_on_start = x
      ds_conds.effective_on_end = x + 1
      ds_conds.weekday_enabled = "true"
      ds_conds.weekday_id = w.id
      ds_conds.week_enabled = "true"
      ds_conds.week = VolunteerShift.week_for_date(x)
      shifts = VolunteerDefaultShift.find(:all, :order => "volunteer_default_shifts.roster_id, volunteer_default_shifts.description", :conditions => ds_conds.conditions(VolunteerDefaultShift), :include => [:volunteer_default_event])
      shifts.each{|ds|
        ve = VolunteerEvent.find(:all, :conditions => ["volunteer_default_event_id = ? AND date = ?", ds.volunteer_default_event_id, x]).first
        if !ve
          ve = VolunteerEvent.new
          ve.volunteer_default_event_id = ds.volunteer_default_event_id
          ve.date = x
        end
        myl = VolunteerEvent.find(:all, :conditions => ["date = ?", x]).map{|y| y.id == ve.id ? ve : y}.map{|y| y.volunteer_shifts}.flatten.select{|y| (ds.volunteer_task_type_id.nil? ? (ds.volunteer_default_event.description == y.volunteer_event.description) : ((ds.volunteer_task_type_id == y.volunteer_task_type_id))) and ((ds.start_time >= y.start_time and ds.start_time < y.end_time) or (ds.end_time > y.start_time and ds.end_time <= y.end_time) or (ds.start_time < y.start_time and ds.end_time > y.end_time))}.map{|y| y.slot_number}
        ve.description = ds.volunteer_default_event.description
        ve.notes = ds.volunteer_default_event.notes
        ve.save!
        slot_number = 1
        (1..ds.slot_count).each{|num|
          while myl.include?(slot_number)
            slot_number += 1
          end
          s = VolunteerShift.new()
          s.volunteer_default_shift_id = ds.id
          s.volunteer_event_id = ve.id
          s.program_id = ds.program_id
          s.description = ds.description
          s.send(:write_attribute, :start_time, ds.start_time)
          s.send(:write_attribute, :end_time, ds.end_time)
          s.volunteer_task_type_id = ds.volunteer_task_type_id
          s.slot_number = slot_number unless ds.not_numbered
          s.not_numbered = ds.not_numbered
          s.stuck_to_assignment = ds.stuck_to_assignment
          s.roster_id = ds.roster_id
          s.class_credit = ds.class_credit
          s.save!
          tweek = s.week.downcase
          tweeknum = s.weeknum
          ds.default_assignments.select{|q| (q.contact_id or q.closed) and ((s.slot_number.nil?) || (q.slot_number == num)) and (q.week.to_s.strip.length == 0 or q.week.downcase == tweek) and (q.send("week_#{tweeknum}_of_month"))}.select{|da| !skip_these.include?(da.id)}.each{|da|
            a = Assignment.new
            a.start_time = da.start_time
            a.end_time = da.end_time
            a.volunteer_shift_id = s.id
            a.contact_id = da.contact_id
            a.closed = da.closed
            a.save!
          }
          if s.assignments.length == 0
            s.destroy
          end
          myl << slot_number
        }
      }
    }
  end

  def my_start_time(format = "%H:%M")
    read_attribute(:start_time).strftime(format)
  end

  def my_start_time=(str)
    write_attribute(:start_time, VolunteerShift._parse_time(str))
  end

  def my_end_time(format = "%H:%M")
    read_attribute(:end_time).strftime(format)
  end

  def my_end_time=(str)
    write_attribute(:end_time, VolunteerShift._parse_time(str))
  end
end
