class AssignmentsController < ApplicationController
  protected

  def get_required_privileges
    a = super
    a << {:privileges => ['schedule_volunteers']}
    a << {:only => ['view'], :privileges => ['schedule_volunteers', 'view_volunteer_schedule']}
    a
  end
  public

  layout :with_sidebar

  helper :skedjul

  def builder_history
    begin
      a = Assignment.find(params[:id])
    rescue
      flash[:jsalert] = "Assignment was deleted before the status sheet could be loaded."
      redirect_skedj(request.env["HTTP_REFERER"], a ? a.volunteer_shift.date_anchor : "")
      return
    end
    if a.contact_id
      redirect_to :action => "builder", :controller => "spec_sheets", :contact => {:id => a.contact_id}
    else
      flash[:jsalert] = "Assignment does not have a contact associated."
      redirect_skedj(request.env["HTTP_REFERER"], a ? a.volunteer_shift.date_anchor : "")
    end
  end

  def notes
    a = Assignment.find_by_id(params[:id])
    c = nil
    if !(a.nil? or a.contact_id.nil?)
      c = a.contact
    end
    str = c.nil? ? "No contact found" : "Contact ##{c.id} notes:\n#{c.notes}".gsub(/\n/, "<br/>")
    if a.has_own_notes
      str += "<hr />Assignment notes:<br />#{a.notes}"
    end
    render :update do |page|
      page.hide loading_indicator_id("skedjul_#{params[:skedjul_loading_indicator_id]}_loading")
      page << "show_message(#{str.to_json});"
    end
  end

  def view
    params["opts"] = {:presentation_mode => "Display"}
    @readonly = true
    index
  end

  def open
    begin
      a = Assignment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:jsalert] = "Assignment was deleted before it could be marked as open"
    end
    a.closed = false if a
    if a && a.valid?
      a.save!
    else
      flash[:jsalert] = "An unknown error prevented the shift from being marked open" if flash[:jsalert].nil?
    end

    redirect_skedj(request.env["HTTP_REFERER"], a ? a.volunteer_shift.date_anchor : "")
  end

  def close
    begin
      a = Assignment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:jsalert] = "Assignment was deleted before it could be marked as closed"
    end
    if a && a.contact_id
      flash[:jsalert] = "Assignment which has a contact cannot be marked as closed"
    end
    a.closed = true if a
    if a && a.valid?
      a.save!
    else
      flash[:jsalert] = "An unknown error prevented the shift from being marked closed" if flash[:jsalert].nil?
    end
    redirect_skedj(request.env["HTTP_REFERER"], a ? a.volunteer_shift.date_anchor : "")
  end

  def index
    @multi_enabled = true
    if params[:conditions]
      my_sort_prepend = params[:conditions][:sked_enabled] == "true" ? "(SELECT position FROM rosters_skeds WHERE sked_id = #{params[:conditions][:sked_id]} AND roster_id = volunteer_shifts.roster_id), " : "volunteer_shifts.roster_id, "
    @skedj = Skedjul.new({
      :conditions => ['contact', "sked", "roster", "volunteer_task_type", "needs_checkin", "assigned", "weekday"],
      :date_range_condition => "date",
      :forced_condition => "cancelled",
      :maximum_date => "VolunteerEvent.maximum(:date)",

      :block_method_name => "volunteer_shifts.volunteer_events.date",
      :block_anchor => 'volunteer_shifts.date_anchor',
      :block_method_display => "volunteer_shifts.date_display",
      :block_start_time => "volunteer_shifts.weekdays.start_time",
      :block_end_time => "volunteer_shifts.weekdays.end_time",
      :default_view => "by_slot",
                           :table_head_partial => "assignments/multi_edit",
                           :cell_onclick => "selection_toggle",

                           :views => {
                             :by_slot =>
                             { :left_unique_value => "volunteer_shifts.left_unique_value", # model
                               :left_sort_value => "#{my_sort_prepend}(coalesce(volunteer_task_types.description, volunteer_events.description)), volunteer_shifts.slot_number",
                               :left_method_name => "volunteer_shifts.left_method_name",
                               :title_between => 'volunteer_shifts.rosters.name',
                               :break_between_difference => "assignments.slot_type_desc",

                               :thing_start_time => "assignments.start_time",
                               :thing_end_time => "assignments.end_time",
                               :thing_table_name => "assignments",
                               :thing_description => "time_range_s,display_name",
                               :thing_link_id => "assignments.id",
                               :thing_links => [[:arrived, :link, :contact_id], [:reassign, :function, :contact_id], [:split, :remote, :contact_id], [:notes, :remote, :has_notes], [:edit, :link], [:builder_history, :link, :if_builder_assigned], [:copy, :link, :volshift_stuck], [:close, :link, :not_assigned, :x], [:open, :link, :closed], [:destroy, :confirm, :contact_id]],
                             },

                             :call_list =>
                             { :left_unique_value => "volunteer_shifts.left_unique_value", # model
                               :left_sort_value => "(coalesce(volunteer_task_types.description, volunteer_events.description)), volunteer_shifts.slot_number",
                               :left_method_name => "volunteer_shifts.left_method_name",
                               :break_between_difference => "assignments.slot_type_desc",

                               :thing_start_time => "assignments.start_time",
                               :thing_end_time => "assignments.end_time",
                               :thing_table_name => "assignments",
                               :thing_description => "time_range_s,display_name,display_call_status,display_phone_numbers",
                               :thing_link_id => "assignments.id",
                               :thing_links => [[:arrived, :link, :contact_id], [:reassign, :function, :contact_id], [:split, :remote, :contact_id], [:notes, :remote, :has_notes], [:edit, :link], [:builder_history, :link, :if_builder_assigned], [:copy, :link, :volshift_stuck], [:close, :link, :not_assigned, :x], [:open, :link, :closed], [:destroy, :confirm, :contact_id]],
                             },

                             :by_worker =>
                             { :left_unique_value => "assignments.contact_id",
                               :left_sort_value => "assignments.contacts.sort_name",
                               :left_method_name => "assignments.contact_display",
                               :left_table_name => "contacts",
#                               :left_link_action => "assignments",
#                               :left_link_id => "contacts.id", # TODO?

                               :thing_start_time => "assignments.start_time",
                               :thing_end_time => "assignments.end_time",
                               :thing_table_name => "assignments",
                               :thing_description => "time_range_s,volunteer_shifts.left_method_name",
                               :thing_link_id => "assignments.id",
                               :thing_links => [[:arrived, :link, :contact_id], [:reassign, :function, :contact_id], [:split, :remote, :contact_id], [:notes, :remote, :has_notes], [:edit, :link], [:builder_history, :link, :if_builder_assigned], [:copy, :link, :volshift_stuck], [:close, :link, :not_assigned, :x], [:open, :link, :closed], [:destroy, :confirm, :contact_id]],
                             }
                           },

      }, params)

    @opts = @skedj.opts
    @conditions = @skedj.conditions
      @page_title = @conditions.skedj_to_s("after", false, ["cancelled"])
      @page_title = "All schedules" if @page_title.length == 0

    @skedj.find({:conditions => @skedj.where_clause, :include => [:attendance_type => [], :volunteer_shift => [:volunteer_task_type, :volunteer_event, :roster], :contact => [], :contact_volunteer_task_type_count => []]})
    render :partial => "work_shifts/skedjul", :locals => {:skedj => @skedj }, :layout => :with_sidebar
    else
      render :partial => "index",  :layout => :with_sidebar
    end
  end

  def reassign
    assigned, available = params[:id].split(",")

    # readonly
    @assigned_orig = Assignment.find(assigned)
    @available = Assignment.find(available)

    if @available.volunteer_shift.stuck_to_assignment or @assigned_orig.volunteer_shift.stuck_to_assignment
      flash[:jsalert] = "Cannot reassign an intern shift, please either delete the intern shift or assign it to somebody else"
    else
      cid = @available.contact_id
      if cid
        @available.contact_id = nil
        @available.save
      end

      # for write
      @assigned = Assignment.find(assigned)
      @new = Assignment.new # available

      # do it
      @assigned.volunteer_shift_id = @available.volunteer_shift_id
      @assigned.start_time = @available.start_time if (@assigned.start_time < @available.start_time) or (@assigned.start_time >= @available.end_time)
      @assigned.end_time = @available.end_time if (@assigned.end_time > @available.end_time) or (@assigned.end_time <= @available.start_time)

      @new.start_time = @available.start_time
      @new.start_time = @assigned_orig.start_time if (@new.start_time < @assigned_orig.start_time) or (@new.start_time >= @assigned_orig.start_time)
      @new.end_time = @available.start_time
      @new.end_time = @assigned_orig.end_time if (@new.end_time > @assigned_orig.end_time) or (@new.end_time <= @assigned_orig.end_time)
      @new.volunteer_shift_id = @assigned_orig.volunteer_shift_id
      @new.contact_id = cid

      @assigned.save!
      @new.save!
    end

    redirect_skedj(request.env["HTTP_REFERER"], @assigned_orig.volunteer_shift.date_anchor)
  end

  def split
    @assignment = Assignment.find(params[:id])
    render :update do |page|
      page.hide loading_indicator_id("skedjul_#{params[:skedjul_loading_indicator_id]}_loading")
      page << "show_message(#{(render :partial => "splitform").to_json});"
    end
  end

  def dosplit
    sp = params[:split].to_a.sort_by{|k,v| k}.map{|a| a[1].to_i}
    @assignment = Assignment.find(params[:id])
    old_end = @assignment.end_time
    @assignment.end_time = @assignment.send(:instantiate_time_object, "split_time", sp)
    new_end = @assignment.end_time
    success = ((@assignment.end_time < old_end) and (@assignment.end_time > @assignment.start_time))
   if success
      success = @assignment.save
      if success
        @assignment = Assignment.new(@assignment.attributes)
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
    begin
      a = Assignment.find(params[:id])
      a.attendance_type = AttendanceType.find_by_name("arrived")
      if !a.valid?
        flash[:jsalert] = a.errors.full_messages.join(", ")
      else
        a.save! # if !a.save ? flash[:error] = "Failed to save record as arrived for unknown reason"
        if a.contact and not a.contact.is_old_enough?
          flash[:jsalert] = "This volunteer is not yet #{Default['minimum_volunteer_age']} years old (based on their saved birthday: #{a.contact.birthday.to_s}).\nPlease remind the volunteer that they must have an adult with them to volunteer."
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:jsalert] = "Assignment was deleted before it could be marked as arrived"
    end
    redirect_skedj(request.env["HTTP_REFERER"], a ? a.volunteer_shift.date_anchor : "")
  end

  def search
    @conditions = Conditions.new
    params[:conditions] ||= {}
    @conditions.apply_conditions(params[:conditions])
    @results = Assignment.paginate(:page => params[:page], :conditions => @conditions.conditions(Assignment), :order => "volunteer_events.date ASC", :per_page => 50, :include => [:volunteer_shift => [:volunteer_event]])
  end

  def copy
    @assignment = Assignment.find(params[:id])
    @my_url = {:action => "create_shift", :controller => "volunteer_events"}
    @assignment.id = nil
    @action_title = "Copying"
    edit
  end

  def edit
    if @assignment
      @assignments = [@assignment]
    else
      begin
        @assignments = params[:id].split(",").map{|x| Assignment.find(x)}
        @assignment = @assignments.first
      rescue
        flash[:error] = $!.to_s
        redirect_skedj(request.env["HTTP_REFERER"], "")
        return
      end
    end
    @referer = request.env["HTTP_REFERER"]
    @my_url ||= {:action => "update", :id => params[:id]}
    render :action => 'edit'
  end

  def update
    @my_url = {:action => "update", :id => params[:id]}
    last_id = nil
    begin
      @assignments = params[:id].split(",").map{|x| last_id = x; Assignment.find(x)}
    rescue ActiveRecord::RecordNotFound
      flash[:jsalert] = "The assignment (##{last_id.to_i.inspect}) seems to have disappeared or never existed. It is possible somebody else has modified or deleted it."
      rt = params[:assignment].delete(:redirect_to)
      redirect_skedj(rt, "")
      return
    end
    rt = params[:assignment].delete(:redirect_to)

    ret = true
    @assignments.each{|x|
      if ret
        @assignment = x
        bc = x.contact_id
        ret = !!(x.update_attributes(params[:assignment]))
        if bc != x.contact_id and x.first_time_in_area?
          alert = "#{x.contact.display_name} (##{x.contact_id}) has never logged hours for the #{x.volunteer_shift.volunteer_task_type.description} task type. Please remind the volunteer of the requirements for this area."
          if x.volunteer_shift.volunteer_event and x.volunteer_shift.volunteer_event.notes and x.volunteer_shift.volunteer_event.notes.length > 0
            alert += "\n\nSome suggested notes saved in the database for this event are:\n" + x.volunteer_shift.volunteer_event.notes
          end
          flash[:jsalert] ||= []
          flash[:jsalert] << alert
        end
      end
    }

    if @assignment.contact and not @assignment.contact.is_old_enough?
      msg = "This volunteer is not yet #{Default['minimum_volunteer_age']} years old (based on their saved birthday: #{@assignment.contact.birthday.to_s}).\nPlease remind the volunteer that they must have an adult with them to volunteer."
      if flash[:jsalert]
        flash[:jsalert].unshift(msg)
      else
        flash[:jsalert] = msg
      end
    end

    if ret
      flash[:notice] = 'Assignment was successfully updated.'
      redirect_skedj(rt, @assignment.volunteer_shift.date_anchor)
    else
      @referer = rt
      render :action => "edit"
    end
  end

  def destroy
    begin
      @assignment = Assignment.find(params[:id])
      @assignment.destroy
    rescue
      flash[:jsalert] = "Record was already deleted"
    end

    redirect_skedj(request.env["HTTP_REFERER"], @assignment ? @assignment.volunteer_shift.date_anchor : "")
  end
end
