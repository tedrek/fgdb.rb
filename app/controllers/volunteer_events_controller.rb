class VolunteerEventsController < ApplicationController
  layout :with_sidebar

  def index
    @volunteer_events = VolunteerEvent.find(:all)
  end

  def show
    @volunteer_event = VolunteerEvent.find(params[:id])
  end

  def new
    @volunteer_event = VolunteerEvent.new
  end

  def edit
    @volunteer_event = VolunteerEvent.find(params[:id])
  end

  def create
    @volunteer_event = VolunteerEvent.new(params[:volunteer_event])

    _save
    if @volunteer_event.save
      _after_save
      flash[:notice] = 'VolunteerEvent was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_event.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_event = VolunteerEvent.find(params[:id])

    _save
    if @volunteer_event.update_attributes(params[:volunteer_event])
      _after_save
      flash[:notice] = 'VolunteerEvent was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_event.id})
    else
      render :action => "edit"
    end
  end

  def _save
    @volunteer_shifts = apply_line_item_data(@volunteer_event, VolunteerShift)
  end

  def _after_save
    @volunteer_shifts.each{|x| x.save!}
  end

  def destroy
    @volunteer_event = VolunteerEvent.find(params[:id])
    @volunteer_event.destroy

    redirect_to({:action => "index"})
  end
end
