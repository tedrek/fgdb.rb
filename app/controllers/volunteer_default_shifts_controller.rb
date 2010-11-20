class VolunteerDefaultShiftsController < ApplicationController
  before_filter :authorized_only
  protected
  def authorized_only
    requires_role('ADMIN')
  end
  public

  layout :with_sidebar

  def index
    @volunteer_default_shifts = VolunteerDefaultShift.find(:all)
  end

  def show
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
  end

  def new
    @volunteer_default_shift = VolunteerDefaultShift.new
  end

  def edit
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
  end

  def create
    @volunteer_default_shift = VolunteerDefaultShift.new(params[:volunteer_default_shift])

    if @volunteer_default_shift.save
      flash[:notice] = 'VolunteerDefaultShift was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_default_shift.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])

    if @volunteer_default_shift.update_attributes(params[:volunteer_default_shift])
      flash[:notice] = 'VolunteerDefaultShift was successfully updated.'
      redirect_to({:action => "show", :id => @volunteer_default_shift.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @volunteer_default_shift = VolunteerDefaultShift.find(params[:id])
    @volunteer_default_shift.destroy

    redirect_to({:action => "index"})
  end
end
