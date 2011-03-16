class AssignmentsController < ApplicationController
  protected

  def get_required_privileges
    a = super
    a << {:privileges => ['schedule_volunteers']}
    a
  end
  public

  layout :with_sidebar

  helper :skedjul

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

  def index
    if params[:conditions]
    @skedj = Skedjul.new({
      :conditions => ['contact', "sked", "roster", "volunteer_task_type", "needs_checkin", "assigned"],
      :date_range_condition => "date",
                           :forced_condition => "cancelled",

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
                               :left_method_name => "volunteer_shifts.left_method_name",
                               :left_sort_value => "(coalesce(volunteer_task_types.description, volunteer_events.description)), volunteer_shifts.slot_number",
                               :left_table_name => "volunteer_shifts",
                               :left_link_action => "assign",
                               :left_link_id => "volunteer_shifts.description_and_slot",

                               :thing_start_time => "assignments.start_time",
                               :thing_end_time => "assignments.end_time",
                               :thing_table_name => "assignments",
                               :thing_description => "display_name",
                               :thing_link_id => "assignments.id",
                               :thing_links => [[:reassign, :function, :contact_id], [:split, :remote, :contact_id], [:notes, :remote, :has_notes], [:edit, :link], [:destroy, :confirm, :contact_id]],
                             },

                             :by_worker =>
                             { :left_unique_value => "assignments.contact_id",
                               :left_sort_value => "assignments.contact_id",
                               :left_method_name => "assignments.contact_display",
                               :left_table_name => "contacts",
                               :left_link_action => "assignments",
                               :left_link_id => "contacts.id",

                               :thing_start_time => "assignments.start_time",
                               :thing_end_time => "assignments.end_time",
                               :thing_table_name => "assignments",
                               :thing_description => "volunteer_shifts.left_method_name",
                               :thing_link_id => "assignments.id",
                               :thing_links => [[:reassign, :function, :contact_id], [:split, :remote, :contact_id], [:notes, :remote, :has_notes], [:edit, :popup], [:destroy, :confirm, :contact_id]],
                             }
                           },

      }, params)

    @opts = @skedj.opts
    @conditions = @skedj.conditions

    @skedj.find({:conditions => @skedj.where_clause, :include => [:attendance_type => [], :contact => [], :volunteer_shift => [:volunteer_task_type, :volunteer_event]]})
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

    # for write
    @assigned = Assignment.find(assigned)
    @new = Assignment.new # available

    # do it
    @assigned.volunteer_shift_id = @available.volunteer_shift_id
    @assigned.start_time = @available.start_time if (@assigned.start_time < @available.start_time) or (@assigned.start_time >= @available.end_time)
    @assigned.end_time = @available.end_time if (@assigned.end_time > @available.end_time) or (@assigned.end_time <= @available.start_time)

    @new.start_time = @assigned_orig.start_time
    @new.end_time = @assigned_orig.end_time
    @new.volunteer_shift_id = @assigned_orig.volunteer_shift_id

    @assigned.save!
    @new.save!

    redirect_skedj(request.env["HTTP_REFERER"], @assigned.volunteer_shift.date_anchor)
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

  def search
    @conditions = Conditions.new
    params[:conditions] ||= {}
    @conditions.apply_conditions(params[:conditions])
    @results = Assignment.paginate(:page => params[:page], :conditions => @conditions.conditions(Assignment), :order => "created_at ASC", :per_page => 50)
  end

  def show
    @assignment = Assignment.find(params[:id])
  end

  def edit
    @assignments = params[:id].split(",").map{|x| Assignment.find(x)}
    @assignment = @assignments.first
    @referer = request.env["HTTP_REFERER"]
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    if @assignment.save
      flash[:notice] = 'Assignment was successfully created.'
      redirect_to({:action => "index", :id => @assignment.id})
    else
      render :action => "new"
    end
  end

  def update
    @assignments = params[:id].split(",").map{|x| Assignment.find(x)}
    @assignment = @assignments.first
    rt = params[:assignment].delete(:redirect_to)

    ret = true
    @assignments.each{|x|
      if ret
        ret = !!(x.update_attributes(params[:assignment]))
      end
    }

    if ret
      flash[:notice] = 'Assignment was successfully updated.'
      redirect_skedj(rt, @assignment.volunteer_shift.date_anchor)
    else
      @referer = rt
      render :action => "edit"
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    redirect_skedj(request.env["HTTP_REFERER"], @assignment.volunteer_shift.date_anchor)
  end
end
