class StationsController < ApplicationController
  layout 'with_sidebar'

  def get_required_privileges
    a = super
    a << {:privileges => ['admin_stations']}
    return a
  end

  # GET /stations
  def index
    @stations = VolunteerTaskType.order(:id).all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /stations/1
  def show
    @station = VolunteerTaskType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /stations/new
  def new
    @station = VolunteerTaskType.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /stations/1/edit
  def edit
    @station = VolunteerTaskType.find(params[:id])
  end

  # POST /stations
  def create
    @station = VolunteerTaskType.new(params[:volunteer_task_type])

    respond_to do |format|
      if @station.save
        format.html do
          redirect_to(@station,
                      :notice => 'Station was successfully created.')
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /stations/1
  def update
    @station = VolunteerTaskType.find(params[:id])

    respond_to do |format|
      if @station.update_attributes(params[:volunteer_task_type])
        format.html do
          redirect_to(@station,
                      :notice => 'Station was successfully updated.')
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # POST /stations/1/disable
  def disable
    @station = VolunteerTaskType.find(params[:id])
    @station.instantiable = false
    if @station.save
      flash[:message] = "Disabled station ##{@station.id}"
    else
      flash[:message] = "Unable to disable station ##{@station.id}: #{@station.errors}"
    end
    respond_to do |format|
      format.html { redirect_to(volunteer_task_types_url) }
    end
  end

  # POST /stations/1/disable
  def enable
    @station = VolunteerTaskType.find(params[:id])
    @station.instantiable = true
    if @station.save
      flash[:message] = "Enabled station ##{@station.id}"
    else
      flash[:message] = "Unable to enable station ##{@station.id}: #{@station.errors}"
    end
    respond_to do |format|
      format.html { redirect_to(volunteer_task_types_url) }
    end
  end

  # DELETE /stations/1
  def destroy
    raise "Unable to destroy stations"
    @station = VolunteerTaskType.find(params[:id])
    @station.destroy

    respond_to do |format|
      format.html { redirect_to(volunteer_task_types_url) }
    end
  end
end
