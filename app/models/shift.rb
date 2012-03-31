class Shift < ActiveRecord::Base
  acts_as_userstamp

  belongs_to :job, :include => [:coverage_type]
  belongs_to :weekday
  belongs_to :worker
  belongs_to :coverage_type
  belongs_to :schedule

  def Shift.and_sql_conds(conds)
    conds + (conds.empty? ? "" : " AND ")
  end

  def Shift.destroy_in_range(start, stop, sql_conditions = '') # work_shifts.
    sql_conditions = Shift.and_sql_conds(sql_conditions)
      # check to see what we will be overwriting:
    sql = "SELECT id FROM work_shifts WHERE shift_date BETWEEN '#{start.to_s}' AND '#{stop.to_s}' AND #{sql_conditions} actual"
      remove = WorkShift.find_by_sql( sql )
      if remove.size > 0
        warning = 'Delete all shifts between #{start.to_s} and #{stop.to_s} (#{remove.size} shifts)?'
        in_clause = Array.new
        remove.each do |shift| 
          in_clause << shift.id
        end
        WorkShift.delete_all "id IN (#{in_clause.join(',')})"
      end
  end

  def Shift.generate(start, stop, sql_conditions = '') # shifts.
    sql_conditions = Shift.and_sql_conds(sql_conditions)
    (start..stop).each do |day|
        # check to see if it's a holiday, if so then skip
      holly = Holiday.is_holiday?(day)
      if holly
          # insert a holiday shift:
      else
          # check to see if the schedule displays on that
          #   weekday, if not then skip
        weekday_id = day.strftime( '%w' )
        weekday = Weekday.find(:first, :conditions => ["id = ?", weekday_id])
          # get standard shifts that match the day of week
            #   order by workers.name, start_time
            # ASSUMPTION: 
            #   either the weekday_id is null
            #   or the shift_date is null
        root_sched = Schedule.find( :first, :conditions => ["? BETWEEN effective_date AND ineffective_date AND parent_id IS NULL", day] )
        in_clause = root_sched.in_clause_family
        where_clause = <<WHERE
        (NOT actual) AND 
        #{sql_conditions}
        ((shifts.effective_date IS NULL OR '#{day}' >= shifts.effective_date)
          AND (shifts.ineffective_date IS NULL OR '#{day}' < shifts.ineffective_date)) AND
        ( 
          ( shifts.shift_date = '#{day}' ) 
            OR
          ( shifts.type IN ('StandardShift','Meeting') AND shifts.schedule_id IN #{in_clause} AND shifts.weekday_id = #{weekday_id} ) 
            OR
          ( shifts.type = 'Unavailability' AND shifts.weekday_id = #{weekday_id} ) 
        )
    
WHERE
            #logger.info 'qqq where_clause: ' + where_clause
        shifts = Shift.find(:all, {
              :conditions => where_clause, 
              :select => 'shifts.*, workers.name', 
              :joins => 'LEFT JOIN workers ON shifts.worker_id = workers.id', 
              :order => 'workers.name, start_time, end_time'} 
            )
        shifts.each do |shift|
          if shift.generates_on_day?(day)
            shift.do_my_generate(day)
          end
        end
      end
      # next
    end
  end

  def generates_on_day?(day)
    raise self.class.to_s
  end

  def save_for_worker?(day, w = self.worker)
    return false unless w
    v = Vacation.find(:first, :conditions => ["worker_id = ? AND ? BETWEEN effective_date AND ineffective_date", w.id, day])
    return true unless v
  end

  def display_name_skedj
    skedj = Thread.current['skedj_obj']
    raise if skedj.nil?
    prepend = ""
    if skedj.opts[:presentation_mode] == "Edit"
      prepend = "[#{self.id}] "
    end
    prepend + display_name
  end

  def display_name
    skedj = Thread.current['skedj_obj']
    s = " (" + self.schedule.name + ")" if self.schedule.id != skedj.conditions.schedule_id
    s ||= ""
    self.name + s
  end

  def read_type
    self.read_attribute(:type)
  end

  def skedjul_link_controller
    self.read_type == 'Meeting' ? "meetings" : "shifts"
  end

  def has_copy
    !(self.read_type == 'Meeting')
  end

    def skedj_style(overlap, last)
      shift_style = ""
      if self.read_type == 'Meeting'
        shift_style = 'meeting'
      elsif self.read_type == 'Unavailability'
        shift_style = 'unavailable'
      elsif self.worker_id == 0
        shift_style = 'unfilled'
      elsif overlap
        # can't seem to get this part quite right
        # i expect a stupid syntax error
        # what should happen:
        # two overlapping anchored shifts should result 
        #   in hardconflict
        # two overlapping shifts where only one is anchored 
        #   should result in mediumconflict
        # other overlapping shifts should result in 
        #   softconflict
        # can't figure out if a shift is anchored?
        #   pretend it is anchored
        if (last.coverage_type ? last.coverage_type.name : 'anchored') == 'anchored'
          if not self.coverage_type
            shift_style = 'hardconflict'
          elsif self.coverage_type.name == 'anchored'
            shift_style = 'hardconflict'
          else
            shift_style = 'mediumconflict'
          end
        elsif self.coverage_type.name == 'anchored'
          shift_style = 'mediumconflict'
        else
          shift_style = 'softconflict'
        end
        # end of problem code
      else
        shift_style = self.proposed ? 'proposed' : self.training ? 'training' : 'shift'
      end
      return shift_style
    end
end
