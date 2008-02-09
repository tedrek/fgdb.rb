class VolunteerTasksController < ApplicationController
  def index
  end

  def check
    if params[:contact] and Contact.exists? params[:contact]
      @contact = Contact.find params[:contact]
      if params[:volunteer_task]
        # replace id numbers with objects
        p = params[:volunteer_task]
        p[:volunteer_task_type] = VolunteerTaskType.find(p[:volunteer_task_type])

        unless p[:community_service_type] == '' or p[:community_service_type].nil?:
          p[:community_service_type] = CommunityServiceType.find(p[:community_service_type])
        else
          p.delete(:community_service_type)
        end

        # do it, and make sure there are no errors
        @volunteer_task = @contact.check p
        if @volunteer_task.errors.empty?
          flash[:thanks] = "Thank you for checking #{@contact.checked_in? ? 'in' : 'out'}"
        else
          return render(:partial => 'check')
        end

      else
        @volunteer_task = VolunteerTask.new
        return render(:partial => 'check')
      end
    end
    render(:partial => 'select_contact') if request.xhr?
  end

  layout :with_sidebar

  def by_volunteer
  end

  def list
  end

  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update
    @show_wrapper = false # don't show the outer wrapper elements if we are just updating an existing scaffold
    component
  end

  def component
    @show_wrapper = true if @show_wrapper.nil?
    @sort_sql = VolunteerTask.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ?
      "#{VolunteerTask.table_name}.#{VolunteerTask.primary_key} asc" :
      @sort_sql  + " " + current_sort_direction(params)
    options = {
      :order => @sort_by,
      :per_page => 20,
      :include => [
        :volunteer_task_type
      ]
    }

    if params.has_key? :contact_id
      @contact = Contact.find(params[:contact_id])
      options[:conditions] = ["contact_id = ?", @contact.id]
    end

    options[:page] = params[:page]
    @volunteer_tasks = VolunteerTask.paginate(options)
    render :action => "component", :layout => false
  end

  def new
    @volunteer_task = VolunteerTask.new
    @volunteer_task.date_performed = Date.today
    @volunteer_task.contact_id = params[:contact_id]
    @successful = true

    return render(:action => 'new.rjs')
  end

  def create
    begin
      @volunteer_task = VolunteerTask.new(params[:volunteer_task])
      @successful = @volunteer_task.save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end

    return render(:action => 'create.rjs')
  end

  def edit
    begin
      @volunteer_task = VolunteerTask.find(params[:id])
      @successful = !@volunteer_task.nil?
    rescue
      flash[:error], @successful  = "<pre>#{$!.backtrace.to_yaml}</pre>", false
    end

    return render(:action => 'edit.rjs')
  end

  def update
    begin
      @volunteer_task = VolunteerTask.find(params[:id])
      @successful = @volunteer_task.update_attributes(params[:volunteer_task])
    rescue
      flash[:error], @successful  = $!.to_s, false
    end

    return render(:action => 'update.rjs')
  end

  def destroy
    begin
      @successful = VolunteerTask.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end

    return render(:action => 'destroy.rjs')
  end

  def cancel
    @successful = true
    return render(:action => 'cancel.rjs')
  end
end
