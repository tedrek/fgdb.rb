class VolunteerDefaultEventsController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['admin_skedjul']}
    a
  end
  public
  layout :with_sidebar

  def index
    @volunteer_default_events = VolunteerDefaultEvent.find(:all)
  end

  def show
    @volunteer_default_event = VolunteerDefaultEvent.find(params[:id])
  end

  def new
    @volunteer_default_event = VolunteerDefaultEvent.new
  end

  def edit
    @volunteer_default_event = VolunteerDefaultEvent.find(params[:id])
    @referer = request.env["HTTP_REFERER"]
  end

  def copy
    redirect_to :action => "show", :id => VolunteerDefaultEvent.find_by_id(params[:id]).copy_to(Weekday.find_by_id(params[:copy][:weekday_id]), hours_val(params[:copy])).id
  end

  def create
    @volunteer_default_event = VolunteerDefaultEvent.new(params[:volunteer_default_event])

    _save
    if @volunteer_default_event.save
      _after_save
      flash[:notice] = 'VolunteerDefaultEvent was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_default_event.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_default_event = VolunteerDefaultEvent.find(params[:id])
    rt = params[:volunteer_default_event].delete(:redirect_to)

    _save
    if @volunteer_default_event.update_attributes(params[:volunteer_default_event])
      _after_save
      flash[:notice] = 'VolunteerDefaultEvent was successfully updated.'
      redirect_skedj(rt, @volunteer_default_event.weekday.name)
    else
      render :action => "edit"
    end
  end

  def _save
    @volunteer_shifts = apply_line_item_data(@volunteer_default_event, VolunteerDefaultShift, 'volunteer_shifts')
    @resources = apply_line_item_data(@volunteer_default_event, ResourcesVolunteerDefaultEvent, 'resources_volunteer_events')
  end

  def _after_save
    @volunteer_shifts.each{|x| x.save!}
    @resources.each{|x| x.save!}
  end

  def destroy
    @volunteer_default_event = VolunteerDefaultEvent.find(params[:id])
    @volunteer_default_event.destroy

    redirect_to({:action => "index"})
  end
end
