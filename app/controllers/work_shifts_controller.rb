class WorkShiftsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    session["shift_return_to"] = "work_shifts"
    session["shift_return_action"] = "list"
    if params[:filter_criteria]
      start = Date.civil(params[:filter_criteria][:"start_date(1i)"].to_i,params[:filter_criteria][:"start_date(2i)"].to_i,params[:filter_criteria][:"start_date(3i)"].to_i)
      stop = Date.civil(params[:filter_criteria][:"end_date(1i)"].to_i,params[:filter_criteria][:"end_date(2i)"].to_i,params[:filter_criteria][:"end_date(3i)"].to_i)

      @opts = params[:filter_criteria]
      @root_sched = Schedule.find( :first, :conditions => ["id = ?", @opts['schedule_id']])
      where_clause = "shift_date BETWEEN '" + start.to_s + "' AND '" + stop.to_s + "'"
      if @opts['limit_to_worker'] and @opts['limit_to_worker'] == '1'
        where_clause += ' AND work_shifts.worker_id = '
        where_clause += @opts['worker_id']
      end
      if @opts['limit_to_job'] and @opts['limit_to_job'] == '1'
        where_clause += ' AND work_shifts.job_id = '
      end
    else
      start = Date.today
      stop = start + 14
      @root_sched = Schedule.find( :first, :order => 'id', :conditions => 'parent_id IS NULL')
      @opts = {
        'schedule_id' => @root_sched.id, 
        'which_way' => 'Family', 
        'limit_to_worker' => '0', 
        'limit_to_job' => '0', 
        'worker_id' => 0, 
        'job_id' => 0,
        'presentation_mode' => 'Edit' }
      where_clause = "shift_date BETWEEN '" + start.to_s + "' AND '" + stop.to_s + "'"
    end

    @work_shifts = WorkShift.find( :all, {
      :select => 'work_shifts.*', 
      :conditions => where_clause, 
      :order => 'work_shifts.shift_date, workers.name, work_shifts.start_time', 
      :joins => 'LEFT JOIN workers ON work_shifts.worker_id = workers.id' }
    )
    render @list
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
        redirect_to :action => session["shift_return_action"], :id => session["shift_return_id"]
      else
        redirect_to :action => 'list', :id => @standard_shift
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
