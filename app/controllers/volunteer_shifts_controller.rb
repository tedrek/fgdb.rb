class VolunteerShiftsController < ApplicationController
  before_filter :authorized_only
  protected
  def authorized_only
    requires_role('ADMIN')
  end
  public

  layout :with_sidebar

  helper :skedjul

  def index
    @volunteer_shifts = VolunteerShift.find(:all)
  end

  def show
    @volunteer_shift = VolunteerShift.find(params[:id])
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
      redirect_to({:action => "show", :id => @volunteer_shift.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_shift = VolunteerShift.find(params[:id])

    if @volunteer_shift.update_attributes(params[:volunteer_shift])
      flash[:notice] = 'VolunteerShift was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_shift.id})
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
