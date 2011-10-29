class WorkShiftsController < ApplicationController
  layout "skedjulnator"

  protected
  before_filter :enable_multi
  def enable_multi
    @multi_enabled = true
  end

  public
  def find_problems
    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])
    @all_dates = (@start_date..@end_date).to_a.select{|x| Weekday.find_by_id(x.wday).is_open}
    @jobs = Job.find_all_by_coverage_type_id(CoverageType.find_by_name("full").id)
    all_shifts = WorkShift.find(:all, :conditions => ['job_id IN (?) AND shift_date >= ? AND shift_date <= ?', @jobs.map{|x| x.id}, @start_date, @end_date])
    @shift_gap_hash = {}
    @jobs.each{|x|
      @shift_gap_hash[x.id] = {}
      @all_dates.each{|d|
        @shift_gap_hash[x.id][d] = [[Time.parse("10:00"), Time.parse("18:00")]]
      }
    }
    all_shifts.each{|x|
      @shift_gap_hash[x.job_id][x.shift_date].push([x.start_time, x.end_time])
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
