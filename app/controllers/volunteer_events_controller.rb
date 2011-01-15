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

    if @volunteer_event.save
      flash[:notice] = 'VolunteerEvent was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_event.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_event = VolunteerEvent.find(params[:id])

    if @volunteer_event.update_attributes(params[:volunteer_event])
      flash[:notice] = 'VolunteerEvent was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_event.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @volunteer_event = VolunteerEvent.find(params[:id])
    @volunteer_event.destroy

    redirect_to({:action => "index"})
  end
end
