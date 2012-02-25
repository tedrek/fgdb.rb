class WorkShiftsController < ApplicationController
  layout "skedjulnator"

  protected
  before_filter :enable_multi
  def enable_multi
    @multi_enabled = true
  end

  public
  def update_rollout_date
    Default["staffsched_rollout_until"] = params[:date]
    redirect_to :back
  end

  def find_problems
    begin
      @start_date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date])
    rescue
      redirect_to :action => "index"
      return
    end
    @disp_end_date = @end_date
    max_end = WorkShift.maximum('shift_date')
    @end_date = max_end if @end_date > max_end and max_end > @start_date
    @conflicts = DB.exec(DB.prepare_sql("SELECT w1.shift_date AS date,workers.name AS worker,COALESCE(job1.name,w1.meeting_name,w1.kind) AS job_1,COALESCE(job2.name,w2.meeting_name,w2.kind) AS job_2,w1.id AS shift_1,w2.id AS shift_2 FROM work_shifts AS w1 INNER JOIN work_shifts AS w2 ON w1.worker_id = w2.worker_id AND w1.shift_date = w2.shift_date AND ((w1.start_time < w2.end_time AND w2.start_time < w1.end_time) OR (w1.start_time > w2.end_time AND w2.start_time > w1.end_time)) AND w1.id < w2.id AND w1.worker_id != 0 LEFT JOIN jobs AS job1 ON job1.id = w1.job_id LEFT JOIN jobs AS job2 ON job2.id = w2.job_id LEFT JOIN workers ON w1.worker_id = workers.id WHERE w1.shift_date >= ? AND w1.shift_date <= ? ORDER BY 1,2;", @start_date, @end_date)).to_a
    @unassigned = DB.exec(DB.prepare_sql("SELECT w1.shift_date AS date,COALESCE(job1.name,w1.meeting_name,w1.kind) || case training when 't' then ' (Training)' else '' end AS job FROM work_shifts AS w1 LEFT JOIN jobs AS job1 ON job1.id = w1.job_id WHERE w1.worker_id = 0 AND w1.shift_date >= ? AND w1.shift_date <= ? ORDER BY 1,2;", @start_date, @end_date)).to_a
    @all_dates = (@start_date..@end_date).to_a.select{|x| Weekday.find_by_id(x.wday).is_open}
    @jobs = Job.find_all_by_coverage_type_id(CoverageType.find_by_name("full").id)
    all_shifts = WorkShift.find(:all, :conditions => ['(training = \'f\' OR training IS NULL) AND job_id IN (?) AND shift_date >= ? AND shift_date <= ?', @jobs.map{|x| x.id}, @start_date, @end_date])
    @shift_gap_hash = {}
    weekday_times = {}
    Weekday.find(:all).each do |w|
      weekday_times[w.id] = [w.open_time, w.close_time]
    end
    @jobs.each{|x|
      @shift_gap_hash[x.id] = {}
      @all_dates.each{|d|
        @shift_gap_hash[x.id][d] = [weekday_times[d.wday]]
      }
    }
    all_shifts.each{|x|
      @shift_gap_hash[x.job_id][x.shift_date].push([x.start_time, x.end_time])
    }
    w_start = @start_date
    while w_start.wday != 1
      w_start -= 1
    end
    w_end = @end_date
    while w_start.wday != 1
      w_start -= 1
    end
    @weeks = (w_start..w_end).to_a.select{|x| x.wday == 1}
    puts @weeks.inspect
    @workers_week_hash = {}
    @workers_day_hash = {}
    @workers = []
    @workers_h = {}
    all_scheduled = WorkShift.find(:all, :conditions => ['shift_date >= ? AND shift_date <= ? AND kind NOT LIKE ?', @weeks.first, (@weeks.last+6), 'Unavailability'], :order => 'shift_date ASC')
    cur_week = @weeks.first
    all_scheduled.each{|w|
      if !@workers.include?(w.worker)
        @workers << w.worker
        @workers_h[w.worker_id] = w.worker
        @workers_week_hash[w.worker_id] = {}
        @weeks.each{|week|
          @workers_week_hash[w.worker_id][week] = 0.0
        }
        @workers_day_hash[w.worker_id] = {}
        (@all_dates).each{|day|
          @workers_day_hash[w.worker_id][day] = [weekday_times[day.wday]]
        }
      end
      if w.shift_date > (cur_week + 6)
        cur_week += 7
      end
      @workers_week_hash[w.worker_id][cur_week] += ((w.end_time - w.start_time)/3600.0)
      if @all_dates.include?(w.shift_date)
        @workers_day_hash[w.worker_id][w.shift_date] << [w.start_time, w.end_time]
      end
    }
    @workers_day_hash.keys.each{|w|
      @workers_day_hash[w].keys.each{|d|
        @workers_day_hash[w][d] = WorkShift.range_math(*@workers_day_hash[w][d])
      }
    }
    @shift_gap_hash.keys.each{|x|
      @shift_gap_hash[x].keys.each{|d|
        @shift_gap_hash[x][d] = WorkShift.range_math(*@shift_gap_hash[x][d])
      }
    }
  end
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['skedjulnator'], :except => ['staffsched', 'staffsched_publish']}
    a
  end

  public

  def index
    list
    render :action => 'list'
  end

  def staffsched_publish
    params["opts"] = {:presentation_mode => "Preview"}
    staffsched
  end

  def staffsched
    @readonly = true
    @vacations = Vacation.find(:all, :order => 'effective_date, ineffective_date', :conditions => ["ineffective_date >= ?", Date.today])
    params["conditions"] ||= {:shift_date_enabled => "true", :shift_date_end_date => (Date.today + 60).to_s, :shift_date_start_date => Date.today.to_s, }
    params["opts"] ||= {:presentation_mode => "Display"}

    list
    render :action => 'list'
  end

  helper :skedjul

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update ], # TODO: destroy should be in this list but the skedjul_links thing needs support for :post
         :redirect_to => { :action => :list }

  def list
    session["shift_return_to"] = "work_shifts"
    session["shift_return_action"] = "list"

    @skedj = Skedjul.new({
      :conditions => ["worker", "job"],
      :date_range_condition => "shift_date",
      :rollout_default_name => "staffsched_rollout_until",
      :rollout_default_action => "update_rollout_date",

      :block_method_name => "work_shifts.shift_date",
      :block_method_display => "work_shifts.shift_date_display",
      :block_start_time => "weekdays.start_time",
      :block_end_time => "weekdays.end_time",

      :left_unique_value => "worker_id",
      :left_method_name => "workers.name",
      :left_table_name => "workers",
      :left_link_action => "edit",
      :left_link_id => "workers.id",

      :thing_start_time => "work_shifts.start_time",
      :thing_end_time => "work_shifts.end_time",
      :thing_table_name => "work_shifts",
      :thing_description => "display_name_skedj",
      :thing_link_id => "work_shifts.id",
      :thing_links => [[:copy, :popup], [:edit, :popup], [:destroy, :confirm]]

      }, params)

    @skedj.find({:include => [:job, :coverage_type, :worker, :weekday]})
  end

  def show
    @work_shift = WorkShift.find(params[:id])
  end

  def new
    @work_shift = WorkShift.new
  end

  def create
    @work_shift = WorkShift.new(params[:work_shift])
    if @work_shift.save
      flash[:notice] = 'WorkShift was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def copy
    @work_shift = WorkShift.find(params[:id])
    @work_shift2 = @work_shift.clone
    if @work_shift2.save
      flash[:notice] = 'WorkShift was successfully copied.'
      redirect_to :action => 'edit', :id => @work_shift2.id
    else
      render :action => 'new'
    end
  end

  def edit
    @work_shift = WorkShift.find(params[:id])
  end

  def update
    @work_shift = WorkShift.find(params[:id])
    if @work_shift.update_attributes(params[:work_shift])
      flash[:notice] = 'WorkShift was successfully updated.'
      if session["shift_return_to"] 
        redirect_to :controller => session["shift_return_to"], :action => session["shift_return_action"], :id => session["shift_return_id"]
      else
        redirect_to :action => 'list', :id => @work_shift
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    WorkShift.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
