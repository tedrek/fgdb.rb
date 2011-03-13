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

                           :views => {
                             :by_slot =>
                             { :left_unique_value => "volunteer_shifts.left_unique_value", # model
                               :left_method_name => "volunteer_shifts.left_method_name",
                               :left_sort_value => "(coalesce(volunteer_task_types.description, volunteer_events.description)), volunteer_shifts.slot_number, volunteer_shifts.description",
                               :left_table_name => "volunteer_shifts",
                               :left_link_action => "assign",
                               :left_link_id => "volunteer_shifts.description_and_slot",

                               :thing_start_time => "assignments.start_time",
                               :thing_end_time => "assignments.end_time",
                               :thing_table_name => "assignments",
                               :thing_description => "display_name",
                               :thing_link_id => "assignments.id",
                               :thing_links => [[:notes, :remote, :has_notes], [:edit, :link], [:destroy, :confirm, :contact_id]],
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
                               :thing_links => [[:notes, :remote, :has_notes], [:edit, :popup], [:destroy, :confirm, :contact_id]],
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
    @assignment = Assignment.find(params[:id])
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
    @assignment = Assignment.find(params[:id])

    redirect_dest = params[:assignment].delete(:redirect_to) || {:action => "index"}
    redirect_dest += "#" + @assignment.volunteer_shift.date_anchor if redirect_dest.class != Hash

    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = 'Assignment was successfully updated.'
      redirect_to(redirect_dest)
    else
      render :action => "edit"
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    redirect_dest = request.env["HTTP_REFERER"] || {:action => "index"}
    redirect_dest += "#" + @assignment.volunteer_shift.date_anchor if redirect_dest.class != Hash

    redirect_to(redirect_dest)
  end
end
