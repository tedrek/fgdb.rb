class DefaultAssignmentsController < ApplicationController
  protected

  def get_required_privileges
    a = super
    a << {:privileges => ['admin_skedjul']}
    a
  end
  public

  layout :with_sidebar

  helper :skedjul

  def index
    if params[:conditions]
    @skedj = Skedjul.new({
      :conditions => ['contact', "sked", "roster", "volunteer_task_type", "assigned", "weekday"],

      :block_method_name => "volunteer_default_shifts.volunteer_default_events.weekday_id",
      :block_method_display => "volunteer_default_shifts.volunteer_default_events.weekdays.name",
      :block_start_time => "volunteer_default_shifts.volunteer_default_events.weekdays.start_time",
      :block_end_time => "volunteer_default_shifts.volunteer_default_events.weekdays.end_time",
#      :default_view => "by_slot",
#                           :table_head_partial => "default_assignments/multi_edit", # TODO: FIXME
                           :cell_onclick => "selection_toggle",

                            :left_unique_value => "default_assignments.left_method_name",
                               :left_method_name => "default_assignments.left_method_name",
                               :left_sort_value => "(coalesce(volunteer_task_types.description, volunteer_default_events.description)), default_assignments.slot_number",
                               :left_table_name => "volunteer_default_shifts",
                               :left_link_action => "assign",
                               :left_link_id => "volunteer_default_shifts.description_and_slot",
#                               :break_between_difference => "default_assignments.slot_type_desc",

                               :thing_start_time => "default_assignments.start_time",
                               :thing_end_time => "default_assignments.end_time",
                               :thing_table_name => "default_assignments",
                               :thing_description => "time_range_s,display_name",
                               :thing_link_id => "default_assignments.id",
                               :thing_links => [[:split, :remote, :contact_id],[:edit, :link], [:destroy, :confirm, :contact_id]], # TODO: [:reassign, :function, :contact_id], 


      }, params)

    @opts = @skedj.opts
    @conditions = @skedj.conditions

    @skedj.find({:conditions => @skedj.where_clause, :include => [:contact => [], :volunteer_default_shift => [:volunteer_task_type, :volunteer_default_event]]})
    render :partial => "work_shifts/skedjul", :locals => {:skedj => @skedj }, :layout => :with_sidebar
    else
      render :partial => "index",  :layout => :with_sidebar
    end
  end

  def reassign
    assigned, available = params[:id].split(",")

    # readonly
    @assigned_orig = DefaultAssignment.find(assigned)
    @available = DefaultAssignment.find(available)

    # for write
    @assigned = DefaultAssignment.find(assigned)
    @new = DefaultAssignment.new # available

    # do it
    @assigned.volunteer_shift_id = @available.volunteer_shift_id
    @assigned.start_time = @available.start_time if (@assigned.start_time < @available.start_time) or (@assigned.start_time >= @available.end_time)
    @assigned.end_time = @available.end_time if (@assigned.end_time > @available.end_time) or (@assigned.end_time <= @available.start_time)

    @new.start_time = @assigned_orig.start_time
    @new.end_time = @assigned_orig.end_time
    @new.volunteer_shift_id = @assigned_orig.volunteer_shift_id

    @assigned.save!
    @new.save!

    redirect_skedj(request.env["HTTP_REFERER"], @assignment.volunteer_default_shift.volunteer_default_event.weekday.name)
  end

  def split
    @assignment = DefaultAssignment.find(params[:id])
    render :update do |page|
      page.hide loading_indicator_id("skedjul_#{params[:skedjul_loading_indicator_id]}_loading")
      page << "show_message(#{(render :partial => "splitform").to_json});"
    end
  end

  def dosplit
    sp = params[:split].to_a.sort_by{|k,v| k}.map{|a| a[1].to_i}
    @assignment = DefaultAssignment.find(params[:id])
    old_end = @assignment.end_time
    @assignment.end_time = @assignment.send(:instantiate_time_object, "split_time", sp)
    new_end = @assignment.end_time
    success = ((@assignment.end_time < old_end) and (@assignment.end_time > @assignment.start_time))
   if success
      success = @assignment.save
      if success
        @assignment = DefaultAssignment.new(@assignment.attributes)
        @assignment.start_time = new_end
        @assignment.end_time = old_end
        success = @assignment.save
      end
    end
    render :update do |page|
      if success
        page.reload
#        page << "selection_toggle(#{params[:id]});"
#        page << "popup1.hide();"
      else
        page << "alert('split failed. this is probably due to the time not being within the correct range.');"
      end
      page.hide loading_indicator_id("split_assignment_form")
    end
  end

  def arrived
    a = DefaultAssignment.find(params[:id])
    a.attendance_type = AttendanceType.find_by_name("arrived")
    a.save!
    redirect_skedj(request.env["HTTP_REFERER"], a.volunteer_shift.date_anchor)
  end

  def search
    @conditions = Conditions.new
    params[:conditions] ||= {}
    @conditions.apply_conditions(params[:conditions])
    @results = Assignment.paginate(:page => params[:page], :conditions => @conditions.conditions(Assignment), :order => "created_at ASC", :per_page => 50)
  end

  def edit
    @assignments = params[:id].split(",").map{|x| DefaultAssignment.find(x)}
    @assignment = @assignments.first
    @referer = request.env["HTTP_REFERER"]
  end

  def update
    @assignments = params[:id].split(",").map{|x| DefaultAssignment.find(x)}
    rt = params[:default_assignment].delete(:redirect_to)

    ret = true
    @assignments.each{|x|
      if ret
        @assignment = x
        ret = !!(x.update_attributes(params[:default_assignment]))
      end
    }

    if ret
      flash[:notice] = 'DefaultAssignment was successfully updated.'
      puts rt
      redirect_skedj(rt, @assignment.volunteer_default_shift.volunteer_default_event.weekday.name)
    else
      @referer = rt
      render :action => "edit"
    end
  end

  def destroy
    @assignment = DefaultAssignment.find(params[:id])
    @assignment.destroy

    redirect_skedj(request.env["HTTP_REFERER"], @assignment.volunteer_default_shift.volunteer_default_event.weekday.name)
  end
end
