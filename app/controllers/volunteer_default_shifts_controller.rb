class VolunteerDefaultShiftsController < ApplicationController
  before_filter :authorized_only
  protected
  def authorized_only
    requires_role('ADMIN')
  end
  public

  layout :with_sidebar

  helper :skedjul

  def generate
    VolunteerDefaultShift.generate(Date.parse(params[:date_range][:start_date]), Date.parse(params[:date_range][:end_date]))
    redirect_to :controller => 'assignments', :action => "index" # TODO: conditions once its there, to show just this date range
  end

  def index
    @conditions = Conditions.new
    @opts = params[:opts] || { 'presentation_mode' => 'Edit' }
    @skedj = Skedjul.new({
      :presentation_mode => @opts["presentation_mode"],
      :generate_params_key => "date_range",
      :conditions => [],

      :block_method_name => "volunteer_default_shifts.weekday_id",
      :block_method_display => "weekdays.name",
      :block_start_time => "weekdays.start_time",
      :block_end_time => "weekdays.end_time",

      :left_unique_value => "volunteer_task_types.id", # model
      :left_method_name => "volunteer_task_types.description",
      :left_table_name => "volunteer_task_types",
      :left_link_action => "new_default_shift",
      :left_link_id => "volunteer_task_types.id",

      :thing_start_time => "volunteer_default_shifts.start_time",
      :thing_end_time => "volunteer_default_shifts.end_time",
      :thing_table_name => "volunteer_default_shifts",
      :thing_description => "slot_count",
      :thing_link_id => "volunteer_default_shifts.id",
      :thing_links => [[:edit, :popup], [:destroy, :confirm]]

      })

    @skedj.find({:conditions => "'t' = 't'", :include => [:volunteer_task_type, :weekday]})
  end

  def show
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
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
      redirect_to({:action => "show", :id => @volunteer_default_shift.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])

    if @volunteer_default_shift.update_attributes(params[:volunteer_default_shift])
      flash[:notice] = 'VolunteerDefaultShift was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_default_shift.id})
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
