class VolunteerDefaultEventsController < ApplicationController
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
  end

  def create
    @volunteer_default_event = VolunteerDefaultEvent.new(params[:volunteer_default_event])

    if @volunteer_default_event.save
      flash[:notice] = 'VolunteerDefaultEvent was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_default_event.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_default_event = VolunteerDefaultEvent.find(params[:id])

    if @volunteer_default_event.update_attributes(params[:volunteer_default_event])
      flash[:notice] = 'VolunteerDefaultEvent was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_default_event.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @volunteer_default_event = VolunteerDefaultEvent.find(params[:id])
    @volunteer_default_event.destroy

    redirect_to({:action => "index"})
  end
end
