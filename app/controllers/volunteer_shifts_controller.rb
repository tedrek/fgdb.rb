class VolunteerShiftsController < ApplicationController
  before_filter :authorized_only
  protected
  def authorized_only
    requires_role('ADMIN')
  end
  public

  layout :with_sidebar

  helper :skedjul

  def index
    @skedj = Skedjul.new({
      :conditions => [],
      :date_range_condition => "date",

      :block_method_name => "volunteer_shifts.date",
      :block_method_display => "volunteer_shifts.date_display",
      :block_start_time => "volunteer_shifts.weekdays.start_time",
      :block_end_time => "volunteer_shifts.weekdays.end_time",

      :left_unique_value => "volunteer_shifts.description_and_slot", # model
      :left_method_name => "volunteer_shifts.volunteer_task_types.description, volunteer_shifts.slot_number",
      :left_table_name => "volunteer_shifts",
      :left_link_action => "new_ds",
      :left_link_id => "volunteer_shifts.description_and_slot",

      :thing_start_time => "volunteer_shifts.start_time",
      :thing_end_time => "volunteer_shifts.end_time",
      :thing_table_name => "volunteer_shifts",
      :thing_description => "volunteer_shifts.time_range_s",
      :thing_link_id => "volunteer_shifts.id",
      :thing_links => [[:edit, :popup], [:destroy, :confirm]]

      }, params)

    @skedj.find({:include => [:volunteer_task_type]})
  end

  def show
    @volunteer_shift = VolunteerShift.find(params[:id])
  end

  def new
    @volunteer_shift = VolunteerShift.new
  end

  def edit
    @volunteer_shift = VolunteerShift.find(params[:id])
  end

  def create
    @volunteer_shift = VolunteerShift.new(params[:volunteer_shift])

    if @volunteer_shift.save
      flash[:notice] = 'VolunteerShift was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_shift.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_shift = VolunteerShift.find(params[:id])

    if @volunteer_shift.update_attributes(params[:volunteer_shift])
      flash[:notice] = 'VolunteerShift was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_shift.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @volunteer_shift = VolunteerShift.find(params[:id])
    @volunteer_shift.destroy

    redirect_to({:action => "index"})
  end
end
