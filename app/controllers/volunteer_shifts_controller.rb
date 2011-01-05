class VolunteerShiftsController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['role_admin']} # FIXME
    a
  end
  public

  layout :with_sidebar

  helper :skedjul

  def index
    if params[:conditions]
    @skedj = Skedjul.new({
      :conditions => ["sked", "roster", "volunteer_task_type"],
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
      :thing_links => [[:copy, :popup], [:edit, :popup], [:destroy, :confirm]]

      }, params)

    @skedj.find({:include => [:volunteer_task_type]})
    render :partial => "work_shifts/skedjul", :locals => {:skedj => @skedj }, :layout => :with_sidebar
    else
      render :partial => "assignments/index", :layout => :with_sidebar
    end
  end

  def copy
    @volunteer_shift = VolunteerShift.find(params[:id])
    @volunteer_shift = @volunteer_shift.clone
    render :action => "new"
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
      redirect_to({:action => "index"})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_shift = VolunteerShift.find(params[:id])

    if @volunteer_shift.update_attributes(params[:volunteer_shift])
      flash[:notice] = 'VolunteerShift was successfully updated.'
      redirect_to({:action => "index"})
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
