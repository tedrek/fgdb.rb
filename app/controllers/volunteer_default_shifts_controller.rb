class VolunteerDefaultShiftsController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['role_admin']} # FIXME
    a
  end
  public

  layout :with_sidebar

  helper :skedjul

  def generate
    gconditions = Conditions.new
    gconditions.apply_conditions(params[:gconditions])
    VolunteerDefaultShift.generate(Date.parse(params[:date_range][:start_date]), Date.parse(params[:date_range][:end_date]), gconditions)
    redirect_to :controller => 'assignments', :action => "index", :conditions => params[:gconditions].merge({:date_start_date => params[:date_range][:start_date], :date_end_date => params[:date_range][:end_date], :date_date_type => "arbitrary", :date_enabled => "true"})
  end

  def index
    if params[:conditions]
    @skedj = Skedjul.new({
      :generate_param_key => "date_range",
      :generate_conditions => ["sked", "roster"],
      :conditions => ["weekday", "sked", "roster", "volunteer_task_type"],

      :block_method_name => "volunteer_default_shifts.volunteer_default_events.weekday_id",
      :block_method_display => "volunteer_default_events.weekdays.name",
      :block_start_time => "volunteer_default_events.weekdays.start_time",
      :block_end_time => "volunteer_default_events.weekdays.end_time",

      :left_unique_value => "volunteer_task_types.id", # model
      :left_method_name => "volunteer_task_types.description",
      :left_table_name => "volunteer_task_types",
      :left_link_action => "new_default_shift",
      :left_link_id => "volunteer_task_types.id",

      :thing_start_time => "volunteer_default_shifts.start_time",
      :thing_end_time => "volunteer_default_shifts.end_time",
      :thing_table_name => "volunteer_default_shifts",
      :thing_description => "describe",
      :thing_link_id => "volunteer_default_shifts.id",
      :thing_links => [[:copy, :popup], [:edit, :popup], [:destroy, :confirm]]

      }, params)

    @skedj.find({:include => [:volunteer_task_type => [], :volunteer_default_event => [:weekday]]})
    render :partial => "work_shifts/skedjul", :locals => {:skedj => @skedj }, :layout => :with_sidebar
    else
      render :partial => "assignments/index", :layout => :with_sidebar
    end
  end

  def copy
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
    @volunteer_default_shift = @volunteer_default_shift.clone
    render :action => "new"
  end

  def new
    @volunteer_default_shift = VolunteerDefaultShift.new
  end

  def edit
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
  end

  def create
    @volunteer_default_shift = VolunteerDefaultShift.new(params[:volunteer_default_shift])

    if @volunteer_default_shift.save
      flash[:notice] = 'VolunteerDefaultShift was successfully created.'
      redirect_to({:action => "index"})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])

    if @volunteer_default_shift.update_attributes(params[:volunteer_default_shift])
      flash[:notice] = 'VolunteerDefaultShift was successfully updated.'
      redirect_to({:action => "index"})
    else
      render :action => "edit"
    end
  end

  def destroy
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
    @volunteer_default_shift.destroy

    redirect_to({:action => "index"})
  end
end
